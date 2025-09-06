class ServerException implements Exception {
  final String message;
  final int? code;
  
  const ServerException({
    required this.message,
    this.code,
  });
}

class NetworkException implements Exception {
  final String message;
  final int? code;
  
  const NetworkException({
    required this.message,
    this.code,
  });
}

class CacheException implements Exception {
  final String message;
  final int? code;
  
  const CacheException({
    required this.message,
    this.code,
  });
}

class ValidationException implements Exception {
  final String message;
  final int? code;
  
  const ValidationException({
    required this.message,
    this.code,
  });
}

class AuthenticationException implements Exception {
  final String message;
  final int? code;
  
  const AuthenticationException({
    required this.message,
    this.code,
  });
}

class AuthorizationException implements Exception {
  final String message;
  final int? code;
  
  const AuthorizationException({
    required this.message,
    this.code,
  });
}

class NotFoundException implements Exception {
  final String message;
  final int? code;
  
  const NotFoundException({
    required this.message,
    this.code,
  });
}

class TimeoutException implements Exception {
  final String message;
  final int? code;
  
  const TimeoutException({
    required this.message,
    this.code,
  });
}

class UnknownException implements Exception {
  final String message;
  final int? code;
  
  const UnknownException({
    required this.message,
    this.code,
  });
}

// Specific Exceptions
class LocationException implements Exception {
  final String message;
  final int? code;
  
  const LocationException({
    required this.message,
    this.code,
  });
}

class PaymentException implements Exception {
  final String message;
  final int? code;
  
  const PaymentException({
    required this.message,
    this.code,
  });
}

class OrderException implements Exception {
  final String message;
  final int? code;
  
  const OrderException({
    required this.message,
    this.code,
  });
}

class RestaurantException implements Exception {
  final String message;
  final int? code;
  
  const RestaurantException({
    required this.message,
    this.code,
  });
}

class CartException implements Exception {
  final String message;
  final int? code;
  
  const CartException({
    required this.message,
    this.code,
  });
}

class NotificationException implements Exception {
  final String message;
  final int? code;
  
  const NotificationException({
    required this.message,
    this.code,
  });
}
