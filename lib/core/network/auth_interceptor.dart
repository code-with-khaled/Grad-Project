// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:grad_project/core/network/api_client.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final Future<String?> Function() getRefreshToken;
  final Future<void> Function(String token) saveToken;

  AuthInterceptor({
    required this.getToken,
    required this.getRefreshToken,
    required this.saveToken,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains("login") || options.path.contains("refresh")) {
      return handler.next(options);
    }

    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    print("➡️ REQUEST: ${options.method} ${options.uri}");
    print("➡️ HEADERS: ${options.headers}");
    print("➡️ BODY: ${options.data}");

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only refresh on 401
    if (err.response?.statusCode == 401) {
      final refresh = await getRefreshToken();
      if (refresh == null) return handler.next(err);

      try {
        // Call refresh endpoint
        final response = await ApiClient.instance.post(
          "/auth/refresh",
          data: {"refreshToken": refresh},
        );

        final newToken = response.data["data"]["accessToken"];

        // Save new token
        await saveToken(newToken);

        // Retry original request
        final retryRequest = await ApiClient.instance.fetch(err.requestOptions);

        return handler.resolve(retryRequest);
      } catch (_) {
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}
