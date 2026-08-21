// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grad_project/features/ePOD/providers/epod_provider.dart';
import 'package:grad_project/features/route/data/epod_artifact_dto.dart';
import 'package:grad_project/features/visits/data/epod_payload_dto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../providers/visit_provider.dart';
import '../models/visit_hive.dart';

class EPODScreen extends StatefulWidget {
  final VisitHive visit;
  final int invoiceId;

  const EPODScreen({super.key, required this.visit, required this.invoiceId});

  @override
  State<EPODScreen> createState() => _EPODScreenState();
}

class _EPODScreenState extends State<EPODScreen> {
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  File? _photo;
  final TextEditingController _notes = TextEditingController();

  bool _saving = false;

  Future<void> _capturePhoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );

    if (img != null) {
      setState(() => _photo = File(img.path));
    }
  }

  Future<String> _saveSignatureLocally() async {
    final bytes = await _sigController.toPngBytes();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/signature_${widget.visit.id}.png");
    await file.writeAsBytes(bytes!);
    return file.path;
  }

  Future<void> _saveEPOD() async {
    if (_saving) return;

    if (_sigController.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signature is required")));
      return;
    }

    if (_photo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Photo is required")));
      return;
    }

    setState(() => _saving = true);

    try {
      final signaturePath = await _saveSignatureLocally();
      final photoPath = _photo!.path;

      if (!mounted) return;

      final visitProvider = context.read<VisitProvider>();
      final epodProvider = context.read<EPODProvider>();

      // 1️⃣ Save signature locally
      final signatureFile = File(signaturePath);

      // 2️⃣ Upload signature → get token
      final signatureToken = await epodProvider.uploadSignature(signatureFile);
      print("signaturePath: $signaturePath");
      print("signatureToken: $signatureToken");

      // 3️⃣ Upload photo → get token
      final photoToken = await epodProvider.uploadPhoto(_photo!);
      print("photoPath: $photoPath");
      print("photoToken: $photoToken");

      // 4️⃣ Build artifacts
      final artifacts = [
        EPODArtifactDto(
          type: "SIGNATURE",
          fileToken: signatureToken,
          capturedAt: formatTimestamp(DateTime.now()),
        ),
        EPODArtifactDto(
          type: "DELIVERY_PHOTO",
          fileToken: photoToken,
          capturedAt: formatTimestamp(DateTime.now()),
        ),
      ];

      // 5️⃣ Build final EPOD payload
      final dto = EPODPayloadDto(
        visitId: widget.visit.id!,
        signatureToken: signatureToken,
        photoToken: photoToken,
        notes: _notes.text,
        artifacts: artifacts,
      );

      // 6️⃣ Submit EPOD for invoice
      await epodProvider.submitEPOD(widget.invoiceId, dto);

      // Save EPOD fields
      visitProvider.addEPOD(
        signaturePath: signaturePath,
        photoPath: photoPath,
        notes: _notes.text,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving ePOD: $e")));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Proof of Delivery")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Signature
            Text("Customer Signature", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(controller: _sigController),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _sigController.clear(),
                child: Text("Clear"),
              ),
            ),
            SizedBox(height: 20),

            // Photo
            Text("Photo Proof", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _photo == null
                ? ElevatedButton.icon(
                    onPressed: _capturePhoto,
                    icon: Icon(Icons.camera_alt),
                    label: Text("Capture Photo"),
                  )
                : Column(
                    children: [
                      Image.file(_photo!, height: 200),
                      TextButton(
                        onPressed: _capturePhoto,
                        child: Text("Retake Photo"),
                      ),
                    ],
                  ),
            SizedBox(height: 20),

            // Notes
            Text("Notes", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              controller: _notes,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Optional notes...",
              ),
            ),
            SizedBox(height: 30),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveEPOD,
                child: _saving
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Finish Visit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(DateTime dt) {
    final withoutMicros = DateTime(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
    );

    return "${withoutMicros.toIso8601String()}+03:00";
  }
}
