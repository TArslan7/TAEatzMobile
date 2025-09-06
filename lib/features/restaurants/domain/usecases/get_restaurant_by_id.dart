import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantById {
  final RestaurantRepository repository;
  
  GetRestaurantById(this.repository);
  
  Future<Either<Failure, RestaurantEntity>> call(String id) async {
    return await repository.getRestaurantById(id);
  }
}
