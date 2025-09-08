import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SearchResultEntity>>> searchAll({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.searchAll(
          query: query,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          limit: limit,
        );
        
        // Save search query to history
        await localDataSource.saveSearchQuery(query);
        
        return Right(results.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SearchResultEntity>>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.searchRestaurants(
          query: query,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          limit: limit,
        );
        
        return Right(results.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SearchResultEntity>>> searchMenuItems({
    required String query,
    String? restaurantId,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.searchMenuItems(
          query: query,
          restaurantId: restaurantId,
          limit: limit,
        );
        
        return Right(results.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions({
    required String query,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final suggestions = await remoteDataSource.getSearchSuggestions(
          query: query,
          limit: limit,
        );
        
        return Right(suggestions);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPopularSearches({
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final popularSearches = await remoteDataSource.getPopularSearches(
          limit: limit,
        );
        
        // Cache popular searches locally
        await localDataSource.savePopularSearches(popularSearches);
        
        return Right(popularSearches);
      } catch (e) {
        // Fallback to local data
        try {
          final localPopularSearches = await localDataSource.getPopularSearches();
          if (localPopularSearches.isNotEmpty) {
            return Right(localPopularSearches.take(limit ?? 10).toList());
          }
          return Left(ServerFailure(message: e.toString()));
        } catch (localError) {
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // Use local data when offline
      try {
        final localPopularSearches = await localDataSource.getPopularSearches();
        return Right(localPopularSearches.take(limit ?? 10).toList());
      } catch (e) {
        return Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchQuery(String query) async {
    try {
      await localDataSource.saveSearchQuery(query);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
