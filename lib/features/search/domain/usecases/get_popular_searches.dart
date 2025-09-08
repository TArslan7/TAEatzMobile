import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/search_repository.dart';

class GetPopularSearches {
  final SearchRepository repository;

  GetPopularSearches(this.repository);

  Future<Either<Failure, List<String>>> call({
    int? limit,
  }) async {
    return await repository.getPopularSearches(limit: limit);
  }
}
