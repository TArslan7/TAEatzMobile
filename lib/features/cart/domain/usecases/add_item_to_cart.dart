import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddItemToCart {
  final CartRepository repository;

  AddItemToCart(this.repository);

  Future<Either<Failure, CartEntity>> call(CartItemEntity item) async {
    return await repository.addItemToCart(item);
  }
}


