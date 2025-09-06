import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/menu_entity.dart';
import '../repositories/menu_repository.dart';

class GetMenuByRestaurantId {
  final MenuRepository repository;
  
  GetMenuByRestaurantId(this.repository);
  
  Future<Either<Failure, MenuEntity>> call(String restaurantId) async {
    return await repository.getMenuByRestaurantId(restaurantId);
  }
}
