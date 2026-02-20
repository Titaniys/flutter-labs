import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../utils/logger.dart';

class ApiClient {
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');

    Logger.debug('GET $uri');

    try {
      final response = await _httpClient
          .get(uri)
          .timeout(AppConstants.apiTimeout);

      Logger.debug('Response status: ${response.statusCode}');
      Logger.debug('Response body: ${response.body}'); // Логируем ответ

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        Logger.debug('Decoded response type: ${decoded.runtimeType}');

        // Если это список, проверим первый элемент
        if (decoded is List && decoded.isNotEmpty) {
          final first = decoded[0];
          if (first is Map<String, dynamic>) {
            final flags = first['flags'];
            Logger.debug('Flags data: $flags');
          }
        }

        return decoded;
      } else if (response.statusCode == 404) {
        throw ApiException('Страна не найдена', code: 404);
      } else {
        throw ApiException('Ошибка сервера: ${response.statusCode}',
            code: response.statusCode);
      }
    } on http.ClientException catch (e) {
      Logger.error('Network error: $e');
      throw ApiException('Нет подключения к интернету', isNetworkError: true);
    } catch (e) {
      Logger.error('Unexpected error: $e');
      throw ApiException('Произошла непредвиденная ошибка');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int? code;
  final bool isNetworkError;

  ApiException(this.message, {this.code, this.isNetworkError = false});

  @override
  String toString() => 'ApiException: $message (code: $code)';
}