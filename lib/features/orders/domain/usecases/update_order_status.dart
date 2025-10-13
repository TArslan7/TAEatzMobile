import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatus {
  final OrderRepository repository;

  UpdateOrderStatus(this.repository);

  Future<Either<Failure, OrderEntity>> call(String orderId, OrderStatus status) async {
    return await repository.updateOrderStatus(orderId, status);
  }
}




