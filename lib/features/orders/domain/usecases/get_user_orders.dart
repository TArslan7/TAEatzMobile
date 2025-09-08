import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetUserOrders {
  final OrderRepository repository;

  GetUserOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(String userId) async {
    return await repository.getUserOrders(userId);
  }
}


