// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'package:grad_project/features/visits/data/epod_payload_dto.dart';
import 'package:http_parser/http_parser.dart';

class EPODRepository {
  final Dio _dio;

  EPODRepository(this._dio);

  // ⭐ Upload ONE file (signature OR photo)
  Future<String> uploadFile(File file) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last,
        contentType: MediaType("image", "png"),
      ),
    });

    final response = await _dio.post(Endpoints.uploadFile, data: formData);

    print(response.data);

    return response.data["data"]["fileToken"];
  }

  Future<void> submitInvoiceEPOD(int invoiceId, EPODPayloadDto dto) async {
    final response = await _dio.post(
      "/invoices/$invoiceId/submit",
      data: dto.toJson(),
    );

    print(response.data);
  }
}
