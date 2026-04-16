import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'https://your-api.com/api/v1';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Состояние обновления токена (чтобы избежать одновременных запросов)
  bool _isRefreshing = false;
  final List<Completer<String>> _tokenRefreshCompleters = [];

  ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Попробовать обновить токен и повторить запрос
          final RequestOptions options = e.requestOptions;
          if (!_isRefreshing) {
            _isRefreshing = true;
            try {
              final newToken = await _refreshToken();
              // Успех: повторить исходный запрос с новым токеном
              options.headers['Authorization'] = 'Bearer $newToken';
              final response = await _dio.fetch(options);
              _isRefreshing = false;
              _completeRefreshCompleters(newToken);
              return handler.resolve(response);
            } catch (refreshError) {
              _isRefreshing = false;
              _completeRefreshCompletersWithError(refreshError);
              // Ошибка обновления — разлогинить пользователя
              await _logoutUser();
              return handler.reject(DioException(
                requestOptions: options,
                error: 'Token refresh failed',
              ));
            }
          } else {
            // Ждём завершения текущего обновления токена
            final completer = Completer<String>();
            _tokenRefreshCompleters.add(completer);
            final newToken = await completer.future;
            options.headers['Authorization'] = 'Bearer $newToken';
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<String> _refreshToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null) throw Exception('No refresh token');
    final response = await _dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    final newAccessToken = response.data['access_token'];
    await _storage.write(key: 'access_token', value: newAccessToken);
    return newAccessToken;
  }

  void _completeRefreshCompleters(String newToken) {
    for (var completer in _tokenRefreshCompleters) {
      completer.complete(newToken);
    }
    _tokenRefreshCompleters.clear();
  }

  void _completeRefreshCompletersWithError(dynamic error) {
    for (var completer in _tokenRefreshCompleters) {
      completer.completeError(error);
    }
    _tokenRefreshCompleters.clear();
  }

  Future<void> _logoutUser() async {
    await _storage.deleteAll();
    //TODO перенаправить на экран входа (через рефреш навигации)
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(String path, {dynamic data}) => _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) => _dio.put(path, data: data);

  Future<Response> delete(String path) => _dio.delete(path);
}