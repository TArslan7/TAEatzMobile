import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';
import '../enums/order_enums.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<Failure, OrderEntity>> getOrder(String orderId);
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId);
  Future<Either<Failure, List<OrderEntity>>> getRestaurantOrders(String restaurantId);
  Future<Either<Failure, OrderEntity>> updateOrderStatus(String orderId, OrderStatus status);
  Future<Either<Failure, OrderEntity>> updatePaymentStatus(String orderId, PaymentStatus status);
  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId);
  Future<Either<Failure, OrderEntity>> reorder(String orderId);
  Future<Either<Failure, OrderEntity>> refundOrder(String orderId);
  Future<Either<Failure, List<OrderEntity>>> getOrdersByStatus(OrderStatus status);
  Future<Either<Failure, OrderEntity>> assignDeliveryDriver(String orderId, String driverId);
  Future<Either<Failure, OrderEntity>> updateDeliveryTime(String orderId, DateTime deliveryTime);
  Future<Either<Failure, OrderEntity>> addTrackingUrl(String orderId, String trackingUrl);
}


