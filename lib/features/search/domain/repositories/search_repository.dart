import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchResultEntity>>> searchAll({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  });

  Future<Either<Failure, List<SearchResultEntity>>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  });

  Future<Either<Failure, List<SearchResultEntity>>> searchMenuItems({
    required String query,
    String? restaurantId,
    int? limit,
  });

  Future<Either<Failure, List<String>>> getSearchSuggestions({
    required String query,
    int? limit,
  });

  Future<Either<Failure, List<String>>> getPopularSearches({
    int? limit,
  });

  Future<Either<Failure, void>> saveSearchQuery(String query);
}
