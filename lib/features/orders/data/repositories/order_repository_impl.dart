import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/enums/order_enums.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = OrderModel.fromEntity(order);
        final createdOrder = await remoteDataSource.createOrder(orderModel);
        return Right(createdOrder.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModels = await remoteDataSource.getUserOrders(userId);
        final orders = orderModels.map((model) => model.toEntity()).toList();
        return Right(orders);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByStatus(OrderStatus status) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModels = await remoteDataSource.getOrdersByStatus(status);
        final orders = orderModels.map((model) => model.toEntity()).toList();
        return Right(orders);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getRestaurantOrders(String restaurantId) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModels = await remoteDataSource.getRestaurantOrders(restaurantId);
        final orders = orderModels.map((model) => model.toEntity()).toList();
        return Right(orders);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.getOrderById(orderId);
        return Right(orderModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(String orderId, OrderStatus status) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.updateOrderStatus(orderId, status.name);
        return Right(orderModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.cancelOrder(orderId);
        return Right(orderModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> reorder(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.reorder(orderId);
        return Right(orderModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrder(String orderId) async {
    return getOrderById(orderId);
  }

  @override
  Future<Either<Failure, OrderEntity>> updatePaymentStatus(String orderId, PaymentStatus status) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.getOrderById(orderId);
        final updatedOrder = orderModel.copyWith(
          paymentStatus: status,
          updatedAt: DateTime.now(),
        );
        return Right(updatedOrder.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> assignDeliveryDriver(String orderId, String driverId) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.getOrderById(orderId);
        final updatedOrder = orderModel.copyWith(
          deliveryDriverId: driverId,
          updatedAt: DateTime.now(),
        );
        return Right(updatedOrder.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateDeliveryTime(String orderId, DateTime deliveryTime) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.getOrderById(orderId);
        final updatedOrder = orderModel.copyWith(
          estimatedDeliveryTime: deliveryTime,
          updatedAt: DateTime.now(),
        );
        return Right(updatedOrder.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> addTrackingUrl(String orderId, String trackingUrl) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.getOrderById(orderId);
        final updatedOrder = orderModel.copyWith(
          trackingUrl: trackingUrl,
          updatedAt: DateTime.now(),
        );
        return Right(updatedOrder.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> refundOrder(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final orderModel = await remoteDataSource.getOrderById(orderId);
        final updatedOrder = orderModel.copyWith(
          paymentStatus: PaymentStatus.refunded,
          status: OrderStatus.cancelled,
          updatedAt: DateTime.now(),
        );
        return Right(updatedOrder.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}