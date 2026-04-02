import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:yumm_ai/core/api/api_endpoints.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;
  final _tokenManager = _TokenManager();

  static void Function()? onTokenExpired;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor(_dio, _tokenManager));

    // Auto retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) {
          // Retry on connection errors and timeouts, not on 4xx/5xx
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    // logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Multipart request for file uploads
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    );
  }

  // Token methods
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _tokenManager.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<String?> getAccessToken() => _tokenManager.getAccessToken();

  Future<String?> getRefreshToken() => _tokenManager.getRefreshToken();

  Future<void> clearTokens() => _tokenManager.clearTokens();
}

class _TokenManager {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}

// Auth Interceptor to add JWT token to requests
class _AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final _TokenManager _tokenManager;

  Completer<bool>? _refreshCompleter;

  static final _publicEndpoints = [ApiEndpoints.login, ApiEndpoints.signup];

  _AuthInterceptor(this._dio, this._tokenManager);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final isPublicEndpoint = _isPublicEndpoint(options);
      final isGoogleApi =
          options.path.contains('googleapis.com') ||
          options.uri.host.contains('googleapis.com');

      if (!isPublicEndpoint && !isGoogleApi) {
        final accessToken = await _tokenManager.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to prepare request: $e',
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;
      final path = options.path;

      final isDeleteVerificationEndpoint =
          path.contains('delete-with-password') ||
          path.contains('delete-with-google') ||
          path.contains('verify-password') ||
          path.contains('change-password');

      if (path == ApiEndpoints.login ||
          path == ApiEndpoints.signup ||
          isDeleteVerificationEndpoint) {
        return handler.next(err);
      }

      try {
        final refreshed = await _refreshToken();

        if (refreshed) {
          final accessToken = await _tokenManager.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } else {
          await _tokenManager.clearTokens();
          ApiClient.onTokenExpired?.call();
          return handler.next(err);
        }
      } catch (e) {
        await _tokenManager.clearTokens();
        ApiClient.onTokenExpired?.call();
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      if ((response.requestOptions.path == ApiEndpoints.login ||
              response.requestOptions.path == ApiEndpoints.signup) &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final accessToken = data['token'] ?? data['accessToken'];
          final refreshToken = data['refreshToken'];

          if (accessToken != null) {
            await _tokenManager.saveTokens(
              accessToken: accessToken.toString(),
              refreshToken: refreshToken?.toString(),
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving tokens from response: $e');
      }
    }

    handler.next(response);
  }

  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await _tokenManager.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        _refreshCompleter = null;
        return false;
      }

      final response = await _dio.post(
        '/auth/refresh', // Change to actual Yumm-AI refresh token endpoint if available
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['token'] ?? data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null) {
          await _tokenManager.saveTokens(
            accessToken: newAccessToken.toString(),
            refreshToken: newRefreshToken?.toString() ?? refreshToken,
          );

          _refreshCompleter!.complete(true);
          _refreshCompleter = null;
          return true;
        }
      }

      _refreshCompleter!.complete(false);
      _refreshCompleter = null;
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh failed: $e');
      }
      _refreshCompleter!.complete(false);
      _refreshCompleter = null;
      return false;
    }
  }

  bool _isPublicEndpoint(RequestOptions options) {
    final isPublicGet =
        options.method == 'GET' &&
        _publicEndpoints.any((endpoint) => options.path.startsWith(endpoint));

    final isAuthEndpoint =
        options.path == ApiEndpoints.login ||
        options.path == ApiEndpoints.signup;

    return isPublicGet || isAuthEndpoint;
  }
}
