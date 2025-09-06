import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/menu_entity.dart';
import '../repositories/menu_repository.dart';

class GetMenuItemsByCategory {
  final MenuRepository repository;
  
  GetMenuItemsByCategory(this.repository);
  
  Future<Either<Failure, List<MenuItemEntity>>> call({
    required String restaurantId,
    required String categoryId,
  }) async {
    return await repository.getMenuItemsByCategory(
      restaurantId: restaurantId,
      categoryId: categoryId,
    );
  }
}
