import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/menu_entity.dart';
import '../repositories/menu_repository.dart';

class SearchMenuItems {
  final MenuRepository repository;
  
  SearchMenuItems(this.repository);
  
  Future<Either<Failure, List<MenuItemEntity>>> call({
    required String restaurantId,
    required String query,
  }) async {
    return await repository.searchMenuItems(
      restaurantId: restaurantId,
      query: query,
    );
  }
}
