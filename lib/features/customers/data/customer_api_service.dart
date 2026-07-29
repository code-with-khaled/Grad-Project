import 'package:dio/dio.dart';
import 'package:grad_project/core/network/api_client.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'customer_dto.dart';

class CustomerApiService {
  final Dio _dio = ApiClient.instance;

  Future<List<CustomerDto>> fetchCustomers() async {
    final response = await _dio.get(
      Endpoints.customers,
      queryParameters: {"status": "ACTIVE", "page": 0, "size": 200},
    );

    final List data = response.data["content"];
    return data.map((e) => CustomerDto.fromJson(e)).toList();
  }

  Future<CustomerDto> fetchCustomerById(int id) async {
    final response = await _dio.get(Endpoints.customerById(id));
    return CustomerDto.fromJson(response.data);
  }
}
