import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_local_datasource.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;
  final RestaurantLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  RestaurantRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants({
    double? latitude,
    double? longitude,
    double? radius,
    String? category,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final restaurants = await remoteDataSource.getRestaurants(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          category: category,
          searchQuery: searchQuery,
          page: page,
          limit: limit,
        );
        
        // Cache the restaurants
        await localDataSource.cacheRestaurants(restaurants);
        
        return Right(restaurants.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedRestaurants = await localDataSource.getCachedRestaurants();
        if (cachedRestaurants.isNotEmpty) {
          return Right(cachedRestaurants.map((model) => model.toEntity()).toList());
        } else {
          return Left(CacheFailure(message: 'No cached data available'));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }
  
  @override
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final restaurant = await remoteDataSource.getRestaurantById(id);
        await localDataSource.cacheRestaurant(restaurant);
        return Right(restaurant.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedRestaurant = await localDataSource.getCachedRestaurantById(id);
        if (cachedRestaurant != null) {
          return Right(cachedRestaurant.toEntity());
        } else {
          return Left(CacheFailure(message: 'Restaurant not found in cache'));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }
  
  @override
  Future<Either<Failure, List<RestaurantEntity>>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    return await getRestaurants(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
  
  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurantsByCategory({
    required String category,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    return await getRestaurants(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      category: category,
    );
  }
  
  @override
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final restaurants = await remoteDataSource.searchRestaurants(
          query: query,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );
        
        return Right(restaurants.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedRestaurants = await localDataSource.getCachedRestaurants();
        final filteredRestaurants = cachedRestaurants.where((restaurant) =>
          restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.description.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.categories.any((category) => 
            category.toLowerCase().contains(query.toLowerCase())
          )
        ).toList();
        
        return Right(filteredRestaurants.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getRestaurantCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getRestaurantCategories();
        await localDataSource.cacheCategories(categories);
        return Right(categories);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedCategories = await localDataSource.getCachedCategories();
        if (cachedCategories.isNotEmpty) {
          return Right(cachedCategories);
        } else {
          return Left(CacheFailure(message: 'No cached categories available'));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getCuisineTypes() async {
    if (await networkInfo.isConnected) {
      try {
        final cuisineTypes = await remoteDataSource.getCuisineTypes();
        await localDataSource.cacheCuisineTypes(cuisineTypes);
        return Right(cuisineTypes);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedCuisineTypes = await localDataSource.getCachedCuisineTypes();
        if (cachedCuisineTypes.isNotEmpty) {
          return Right(cachedCuisineTypes);
        } else {
          return Left(CacheFailure(message: 'No cached cuisine types available'));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }
}
