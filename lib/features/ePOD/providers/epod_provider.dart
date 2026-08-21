import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grad_project/features/ePOD/data/epod_repository.dart';
import 'package:grad_project/features/visits/data/epod_payload_dto.dart';

class EPODProvider extends ChangeNotifier {
  final EPODRepository _repo;

  EPODProvider(this._repo);

  Future<String> uploadSignature(File file) async {
    return await _repo.uploadFile(file);
  }

  Future<String> uploadPhoto(File file) async {
    return await _repo.uploadFile(file);
  }

  Future<void> submitEPOD(int invoiceId, EPODPayloadDto dto) async {
    await _repo.submitInvoiceEPOD(invoiceId, dto);
  }
}
