import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateItemQuantity {
  final CartRepository repository;

  UpdateItemQuantity(this.repository);

  Future<Either<Failure, CartEntity>> call(String itemId, int quantity) async {
    if (quantity <= 0) {
      return await repository.removeItemFromCart(itemId);
    }
    return await repository.updateItemQuantity(itemId, quantity);
  }
}


