import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/search_result_entity.dart';
import '../repositories/search_repository.dart';

class SearchAll {
  final SearchRepository repository;

  SearchAll(this.repository);

  Future<Either<Failure, List<SearchResultEntity>>> call({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  }) async {
    return await repository.searchAll(
      query: query,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      limit: limit,
    );
  }
}
