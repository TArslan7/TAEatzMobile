import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

  Future<Either<Failure, CartEntity>> call() async {
    return await repository.getCart();
  }
}


