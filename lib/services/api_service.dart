import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../helpers/auth_helper.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  static const String _serverUnreachableMessage =
      'Tidak dapat terhubung ke server. Pastikan:\n'
      '1. Backend berjalan di port 3000\n'
      '2. Gunakan http://10.0.2.2:3000/api untuk emulator Android\n'
      '3. Atau gunakan IP komputer Anda untuk real device';

  static dynamic _decodeJson(String body) {
    return jsonDecode(body);
  }

  // Helper method to get headers
  static Future<Map<String, String>> _getHeaders({
    bool requiresAuth = true,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await AuthHelper.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Helper method to handle response
  static Future<dynamic> _handleResponse(http.Response response) async {
    final statusCode = response.statusCode;

    try {
      final body = response.body;

      // Some endpoints may return an empty body (e.g., 204) or non-JSON errors.
      // Keep parsing resilient and avoid throwing JSON decode errors.
      dynamic data;
      if (body.trim().isEmpty) {
        data = <String, dynamic>{};
      } else {
        try {
          // Parse JSON off the UI isolate to avoid jank/ANR on large payloads.
          data = await compute(_decodeJson, body);
        } catch (_) {
          data = <String, dynamic>{'message': body};
        }
      }

      if (statusCode >= 200 && statusCode < 300) {
        return data;
      } else {
        final errorMessage = (data is Map)
            ? (data['error'] ?? data['message'] ?? 'Terjadi kesalahan')
            : 'Terjadi kesalahan';
        throw ApiException(errorMessage, statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Gagal memproses response: ${e.toString()}',
        statusCode,
      );
    }
  }

  // GET request
  static Future<dynamic> get(
    String endpoint, {
    bool requiresAuth = true,
    Duration? timeout,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .get(url, headers: headers)
          .timeout(timeout ?? ApiConfig.timeoutDuration);

      return await _handleResponse(response);
    } on SocketException {
      throw ApiException(_serverUnreachableMessage);
    } on TimeoutException {
      throw ApiException('Request timeout. Coba lagi nanti.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // POST request with retry logic
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
    int retryCount = 0,
    Duration? timeout,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      debugPrint('POST request to: $url');
      debugPrint('Request body: ${jsonEncode(body)}');

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(timeout ?? ApiConfig.timeoutDuration);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      return await _handleResponse(response);
    } on SocketException catch (e) {
      debugPrint('SocketException: $e');
      throw ApiException(_serverUnreachableMessage);
    } on TimeoutException catch (e) {
      debugPrint('TimeoutException: $e (attempt ${retryCount + 1})');

      // Retry logic
      if (retryCount < ApiConfig.maxRetries) {
        debugPrint(
          'Retrying request... (${retryCount + 1}/${ApiConfig.maxRetries})',
        );
        await Future.delayed(Duration(seconds: 1));
        return post(
          endpoint,
          body,
          requiresAuth: requiresAuth,
          retryCount: retryCount + 1,
          timeout: timeout,
        );
      }

      throw ApiException(
        'Request timeout setelah ${ApiConfig.maxRetries + 1} percobaan.\n'
        'Pastikan backend berjalan dan dapat diakses.',
      );
    } catch (e) {
      debugPrint('Error: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // PUT request
  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
    Duration? timeout,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(timeout ?? ApiConfig.timeoutDuration);

      return await _handleResponse(response);
    } on SocketException {
      throw ApiException(_serverUnreachableMessage);
    } on TimeoutException {
      throw ApiException('Request timeout. Coba lagi nanti.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // DELETE request
  static Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
    Duration? timeout,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .delete(url, headers: headers)
          .timeout(timeout ?? ApiConfig.timeoutDuration);

      return await _handleResponse(response);
    } on SocketException {
      throw ApiException(_serverUnreachableMessage);
    } on TimeoutException {
      throw ApiException('Request timeout. Coba lagi nanti.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // PATCH request
  static Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
    Duration? timeout,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .patch(url, headers: headers, body: jsonEncode(body))
          .timeout(timeout ?? ApiConfig.timeoutDuration);

      return await _handleResponse(response);
    } on SocketException {
      throw ApiException(_serverUnreachableMessage);
    } on TimeoutException {
      throw ApiException('Request timeout. Coba lagi nanti.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
