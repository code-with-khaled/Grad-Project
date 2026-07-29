import 'package:dio/dio.dart';

class ErrorHandler {
  static String parse(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return "Connection timeout. Please try again.";
    }

    if (error.type == DioExceptionType.connectionError) {
      return "No internet connection.";
    }

    if (error.response != null) {
      final status = error.response!.statusCode;

      if (status == 400) return "Bad request.";
      if (status == 401) return "Unauthorized.";
      if (status == 403) return "Forbidden.";
      if (status == 404) return "Not found.";
      if (status == 500) return "Server error.";

      return "Unexpected error: $status";
    }

    return "Unexpected error occurred.";
  }
}
