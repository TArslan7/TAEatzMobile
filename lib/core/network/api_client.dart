import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class ApiClient {
  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();
  
  ApiClient._();

  late Dio _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
      connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Key': AppConstants.apiKey,
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
      _RetryInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  // REST API Methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // WebSocket connection
  Future<Response> connectWebSocket(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // File upload
  Future<Response> uploadFile(String path, String filePath, {Map<String, dynamic>? data}) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        ...?data,
      });
      return await _dio.post(path, data: formData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('Connection timeout. Please check your internet connection.');
        case DioExceptionType.sendTimeout:
          return Exception('Request timeout. Please try again.');
        case DioExceptionType.receiveTimeout:
          return Exception('Response timeout. Please try again.');
        case DioExceptionType.badResponse:
          return Exception('Server error: ${error.response?.statusCode}');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        case DioExceptionType.connectionError:
          return Exception('Connection error. Please check your internet connection.');
        default:
          return Exception('An unexpected error occurred');
      }
    }
    return Exception('An unexpected error occurred');
  }
}

// Auth Interceptor
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    final token = _getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  String? _getAuthToken() {
    // Get token from secure storage
    return null; // Implement token retrieval
  }
}

// Logging Interceptor
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
      debugPrint('Headers: ${options.headers}');
      debugPrint('Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      debugPrint('Data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      debugPrint('Message: ${err.message}');
    }
    handler.next(err);
  }
}

// Error Interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific error cases
    if (err.response?.statusCode == 401) {
      // Handle unauthorized access
      _handleUnauthorized();
    } else if (err.response?.statusCode == 403) {
      // Handle forbidden access
      _handleForbidden();
    } else if (err.response?.statusCode == 500) {
      // Handle server error
      _handleServerError();
    }
    handler.next(err);
  }

  void _handleUnauthorized() {
    // Clear auth token and redirect to login
    debugPrint('Unauthorized access - redirecting to login');
  }

  void _handleForbidden() {
    // Handle forbidden access
    debugPrint('Forbidden access');
  }

  void _handleServerError() {
    // Handle server error
    debugPrint('Server error');
  }
}

// Retry Interceptor
class _RetryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // If retry fails, continue with original error
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final dio = Dio();
    return await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }
}

// API Endpoints
class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String deleteAccount = '/user/account';

  // Restaurant endpoints
  static const String restaurants = '/restaurants';
  static const String restaurantById = '/restaurants/{id}';
  static const String searchRestaurants = '/restaurants/search';
  static const String restaurantCategories = '/restaurants/categories';

  // Menu endpoints
  static const String menuByRestaurant = '/restaurants/{id}/menu';
  static const String menuItems = '/menu/items';
  static const String searchMenuItems = '/menu/search';

  // Order endpoints
  static const String orders = '/orders';
  static const String orderById = '/orders/{id}';
  static const String createOrder = '/orders';
  static const String cancelOrder = '/orders/{id}/cancel';
  static const String reorder = '/orders/{id}/reorder';

  // Payment endpoints
  static const String paymentMethods = '/payments/methods';
  static const String createPayment = '/payments/create';
  static const String confirmPayment = '/payments/confirm';
  static const String refundPayment = '/payments/{id}/refund';

  // Tracking endpoints
  static const String trackOrder = '/orders/{id}/track';
  static const String trackingUpdates = '/orders/{id}/tracking';

  // Review endpoints
  static const String reviews = '/reviews';
  static const String createReview = '/reviews';
  static const String updateReview = '/reviews/{id}';
  static const String deleteReview = '/reviews/{id}';

  // Search endpoints
  static const String search = '/search';
  static const String searchSuggestions = '/search/suggestions';
  static const String searchHistory = '/search/history';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/{id}/read';
  static const String notificationSettings = '/notifications/settings';

  // Analytics endpoints
  static const String analytics = '/analytics';
  static const String userBehavior = '/analytics/behavior';
  static const String performance = '/analytics/performance';

  // WebSocket endpoints
  static const String wsConnection = '/ws';
  static const String wsOrders = '/ws/orders';
  static const String wsTracking = '/ws/tracking';
  static const String wsNotifications = '/ws/notifications';
}