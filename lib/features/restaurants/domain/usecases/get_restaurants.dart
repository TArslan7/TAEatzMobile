import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurants {
  final RestaurantRepository repository;
  
  GetRestaurants(this.repository);
  
  Future<Either<Failure, List<RestaurantEntity>>> call({
    double? latitude,
    double? longitude,
    double? radius,
    String? category,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    return await repository.getRestaurants(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      category: category,
      searchQuery: searchQuery,
      page: page,
      limit: limit,
    );
  }
}
