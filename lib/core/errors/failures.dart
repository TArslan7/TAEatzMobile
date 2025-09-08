import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
}

// General Failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.code,
  });
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required super.message,
    super.code,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });
}

// Specific Failures
class LocationFailure extends Failure {
  const LocationFailure({
    required super.message,
    super.code,
  });
}

class PaymentFailure extends Failure {
  const PaymentFailure({
    required super.message,
    super.code,
  });
}

class OrderFailure extends Failure {
  const OrderFailure({
    required super.message,
    super.code,
  });
}

class RestaurantFailure extends Failure {
  const RestaurantFailure({
    required super.message,
    super.code,
  });
}

class CartFailure extends Failure {
  const CartFailure({
    required super.message,
    super.code,
  });
}

class NotificationFailure extends Failure {
  const NotificationFailure({
    required super.message,
    super.code,
  });
}

class UnimplementedFailure extends Failure {
  const UnimplementedFailure({
    super.message = 'Feature not implemented',
    super.code,
  });
}
