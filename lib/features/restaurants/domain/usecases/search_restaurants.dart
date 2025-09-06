import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class SearchRestaurants {
  final RestaurantRepository repository;
  
  SearchRestaurants(this.repository);
  
  Future<Either<Failure, List<RestaurantEntity>>> call({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    return await repository.searchRestaurants(
      query: query,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
}
