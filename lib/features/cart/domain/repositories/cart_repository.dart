import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> addItemToCart(CartItemEntity item);
  Future<Either<Failure, CartEntity>> updateItemQuantity(String itemId, int quantity);
  Future<Either<Failure, CartEntity>> removeItemFromCart(String itemId);
  Future<Either<Failure, CartEntity>> clearCart();
  Future<Either<Failure, CartEntity>> updateSpecialInstructions(String itemId, String? instructions);
  Future<Either<Failure, CartEntity>> addItemOption(String itemId, CartItemOptionEntity option);
  Future<Either<Failure, CartEntity>> removeItemOption(String itemId, String optionId);
}


