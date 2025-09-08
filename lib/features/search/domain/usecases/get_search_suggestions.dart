import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/search_repository.dart';

class GetSearchSuggestions {
  final SearchRepository repository;

  GetSearchSuggestions(this.repository);

  Future<Either<Failure, List<String>>> call({
    required String query,
    int? limit,
  }) async {
    return await repository.getSearchSuggestions(
      query: query,
      limit: limit,
    );
  }
}
