import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class RemoveItemFromCart {
  final CartRepository repository;

  RemoveItemFromCart(this.repository);

  Future<Either<Failure, CartEntity>> call(String itemId) async {
    return await repository.removeItemFromCart(itemId);
  }
}


