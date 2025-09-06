import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants({
    double? latitude,
    double? longitude,
    double? radius,
    String? category,
    String? searchQuery,
    int? page,
    int? limit,
  });
  
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id);
  
  Future<Either<Failure, List<RestaurantEntity>>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  });
  
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurantsByCategory({
    required String category,
    double? latitude,
    double? longitude,
    double? radius,
  });
  
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
  });
  
  Future<Either<Failure, List<String>>> getRestaurantCategories();
  
  Future<Either<Failure, List<String>>> getCuisineTypes();
}
