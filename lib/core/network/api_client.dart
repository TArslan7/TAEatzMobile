import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl + AppConstants.apiVersion)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;
  
  // Authentication Endpoints
  @POST('/auth/login')
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> loginData);
  
  @POST('/auth/register')
  Future<Map<String, dynamic>> register(@Body() Map<String, dynamic> registerData);
  
  @POST('/auth/logout')
  Future<Map<String, dynamic>> logout(@Header('Authorization') String token);
  
  @POST('/auth/refresh')
  Future<Map<String, dynamic>> refreshToken(@Body() Map<String, dynamic> refreshData);
  
  @POST('/auth/forgot-password')
  Future<Map<String, dynamic>> forgotPassword(@Body() Map<String, dynamic> emailData);
  
  @POST('/auth/reset-password')
  Future<Map<String, dynamic>> resetPassword(@Body() Map<String, dynamic> resetData);
  
  // User Endpoints
  @GET('/user/profile')
  Future<Map<String, dynamic>> getUserProfile(@Header('Authorization') String token);
  
  @PUT('/user/profile')
  Future<Map<String, dynamic>> updateUserProfile(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> profileData,
  );
  
  @GET('/user/addresses')
  Future<Map<String, dynamic>> getUserAddresses(@Header('Authorization') String token);
  
  @POST('/user/addresses')
  Future<Map<String, dynamic>> addUserAddress(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> addressData,
  );
  
  @PUT('/user/addresses/{id}')
  Future<Map<String, dynamic>> updateUserAddress(
    @Header('Authorization') String token,
    @Path('id') String addressId,
    @Body() Map<String, dynamic> addressData,
  );
  
  @DELETE('/user/addresses/{id}')
  Future<Map<String, dynamic>> deleteUserAddress(
    @Header('Authorization') String token,
    @Path('id') String addressId,
  );
  
  // Restaurant Endpoints
  @GET('/restaurants')
  Future<Map<String, dynamic>> getRestaurants(
    @Query('lat') double? latitude,
    @Query('lng') double? longitude,
    @Query('radius') double? radius,
    @Query('category') String? category,
    @Query('search') String? search,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );
  
  @GET('/restaurants/{id}')
  Future<Map<String, dynamic>> getRestaurant(@Path('id') String restaurantId);
  
  @GET('/restaurants/{id}/menu')
  Future<Map<String, dynamic>> getRestaurantMenu(@Path('id') String restaurantId);
  
  @GET('/restaurants/{id}/reviews')
  Future<Map<String, dynamic>> getRestaurantReviews(
    @Path('id') String restaurantId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );
  
  // Order Endpoints
  @POST('/orders')
  Future<Map<String, dynamic>> createOrder(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> orderData,
  );
  
  @GET('/orders')
  Future<Map<String, dynamic>> getUserOrders(
    @Header('Authorization') String token,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('status') String? status,
  );
  
  @GET('/orders/{id}')
  Future<Map<String, dynamic>> getOrder(
    @Header('Authorization') String token,
    @Path('id') String orderId,
  );
  
  @PUT('/orders/{id}/cancel')
  Future<Map<String, dynamic>> cancelOrder(
    @Header('Authorization') String token,
    @Path('id') String orderId,
  );
  
  @POST('/orders/{id}/rate')
  Future<Map<String, dynamic>> rateOrder(
    @Header('Authorization') String token,
    @Path('id') String orderId,
    @Body() Map<String, dynamic> ratingData,
  );
  
  // Payment Endpoints
  @POST('/payments/create-intent')
  Future<Map<String, dynamic>> createPaymentIntent(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> paymentData,
  );
  
  @POST('/payments/confirm')
  Future<Map<String, dynamic>> confirmPayment(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> paymentData,
  );
  
  // Search Endpoints
  @GET('/search/restaurants')
  Future<Map<String, dynamic>> searchRestaurants(
    @Query('q') String query,
    @Query('lat') double? latitude,
    @Query('lng') double? longitude,
    @Query('radius') double? radius,
    @Query('category') String? category,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );
  
  @GET('/search/dishes')
  Future<Map<String, dynamic>> searchDishes(
    @Query('q') String query,
    @Query('lat') double? latitude,
    @Query('lng') double? longitude,
    @Query('radius') double? radius,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );
  
  // Notification Endpoints
  @GET('/notifications')
  Future<Map<String, dynamic>> getNotifications(
    @Header('Authorization') String token,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );
  
  @PUT('/notifications/{id}/read')
  Future<Map<String, dynamic>> markNotificationAsRead(
    @Header('Authorization') String token,
    @Path('id') String notificationId,
  );
  
  @PUT('/notifications/read-all')
  Future<Map<String, dynamic>> markAllNotificationsAsRead(
    @Header('Authorization') String token,
  );
}

class ApiClientFactory {
  static ApiClient create() {
    final dio = Dio();
    
    // Add interceptors
    dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
    
    // Configure timeouts
    dio.options.connectTimeout = const Duration(milliseconds: AppConstants.connectionTimeout);
    dio.options.receiveTimeout = const Duration(milliseconds: AppConstants.receiveTimeout);
    
    return ApiClient(dio);
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authorization header if token exists
    // This will be implemented when we add token management
    super.onRequest(options, handler);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(
          message: 'Connection timeout. Please check your internet connection.',
          code: err.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = err.response?.data?['message'] ?? 'An error occurred';
        
        switch (statusCode) {
          case 400:
            throw ValidationException(message: message, code: statusCode);
          case 401:
            throw AuthenticationException(message: message, code: statusCode);
          case 403:
            throw AuthorizationException(message: message, code: statusCode);
          case 404:
            throw NotFoundException(message: message, code: statusCode);
          case 500:
            throw ServerException(message: message, code: statusCode);
          default:
            throw ServerException(message: message, code: statusCode);
        }
      case DioExceptionType.cancel:
        throw NetworkException(message: 'Request was cancelled', code: err.response?.statusCode);
      case DioExceptionType.connectionError:
        throw NetworkException(message: 'No internet connection', code: err.response?.statusCode);
      case DioExceptionType.badCertificate:
        throw NetworkException(message: 'Certificate error', code: err.response?.statusCode);
      case DioExceptionType.unknown:
        throw UnknownException(message: 'An unknown error occurred', code: err.response?.statusCode);
    }
  }
}
