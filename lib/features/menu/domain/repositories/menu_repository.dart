import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/menu_entity.dart';

abstract class MenuRepository {
  Future<Either<Failure, MenuEntity>> getMenuByRestaurantId(String restaurantId);
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItemsByCategory({
    required String restaurantId,
    required String categoryId,
  });
  Future<Either<Failure, MenuItemEntity>> getMenuItemById({
    required String restaurantId,
    required String itemId,
  });
  Future<Either<Failure, List<MenuItemEntity>>> searchMenuItems({
    required String restaurantId,
    required String query,
  });
  Future<Either<Failure, List<MenuItemEntity>>> getPopularItems(String restaurantId);
  Future<Either<Failure, List<MenuItemEntity>>> getRecommendedItems(String restaurantId);
}
