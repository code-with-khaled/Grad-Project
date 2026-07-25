import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grad_project/features/visits/screens/visit_completed_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/services/location_service.dart';
import '../providers/visit_provider.dart';
import '../../customers/providers/customer_provider.dart';
import '../models/visit_hive.dart';

class EPODScreen extends StatefulWidget {
  final VisitHive visit;

  const EPODScreen({super.key, required this.visit});

  @override
  State<EPODScreen> createState() => _EPODScreenState();
}

class _EPODScreenState extends State<EPODScreen> {
  final SignatureController _sigController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  File? _photo;
  LatLng? _gps;
  final TextEditingController _notes = TextEditingController();

  bool _saving = false;

  Future<void> _capturePhoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);

    if (img != null) {
      setState(() => _photo = File(img.path));
    }
  }

  Future<void> _captureGPS() async {
    final pos = await LocationService.getCurrentLocation();
    setState(() => _gps = pos);
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

    if (_gps == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("GPS location is required")));
      return;
    }

    setState(() => _saving = true);

    try {
      final signaturePath = await _saveSignatureLocally();
      final photoPath = _photo!.path;

      if (!mounted) return;

      final visitProvider = context.read<VisitProvider>();
      final customerProvider = context.read<CustomerProvider>();

      // Save EPOD fields
      visitProvider.addEPOD(
        signaturePath: signaturePath,
        photoPath: photoPath,
        deliveryLat: _gps!.latitude,
        deliveryLng: _gps!.longitude,
        notes: _notes.text,
      );

      // Finish visit
      visitProvider.finishVisit(_gps!, customerProvider);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VisitCompletedScreen(
            data: {
              "id": widget.visit.id,
              "customerId": widget.visit.customerId,
              "startTime": widget.visit.startTime.toIso8601String(),
              "startLat": widget.visit.startLat,
              "startLng": widget.visit.startLng,
              "endTime": DateTime.now().toIso8601String(),
              "endLat": _gps!.latitude,
              "endLng": _gps!.longitude,
              "status": "completed",
            },
          ),
        ),
      );
    } catch (e) {
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

            // GPS
            Text("GPS Location", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _gps == null
                ? ElevatedButton.icon(
                    onPressed: _captureGPS,
                    icon: Icon(Icons.location_on),
                    label: Text("Capture GPS"),
                  )
                : Text("Captured: ${_gps!.latitude}, ${_gps!.longitude}"),
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
}
