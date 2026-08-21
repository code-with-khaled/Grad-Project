// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'invoice_dto.dart';

class InvoiceApiService {
  final Dio _dio;

  InvoiceApiService(this._dio);

  Future<InvoiceDto> createInvoice(Map<String, dynamic> payload) async {
    final response = await _dio.post(Endpoints.invoices, data: payload);

    print(response.data);

    return InvoiceDto.fromJson(response.data['data']);
  }

  Future<InvoiceDto> updateInvoice(int id, Map<String, dynamic> payload) async {
    final response = await _dio.put(Endpoints.invoiceById(id), data: payload);

    return InvoiceDto.fromJson(response.data);
  }

  Future<void> submitInvoice(int id) async {
    await _dio.post(Endpoints.submitInvoice(id));
  }

  Future<List<InvoiceDto>> fetchInvoices(int repId) async {
    final response = await _dio.get(
      Endpoints.invoices,
      queryParameters: {"repId": repId},
    );

    final List data = response.data["content"];
    return data.map((e) => InvoiceDto.fromJson(e)).toList();
  }
}
