import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  MenuRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, MenuEntity>> getMenuByRestaurantId(String restaurantId) async {
    if (await networkInfo.isConnected) {
      try {
        final menu = await remoteDataSource.getMenuByRestaurantId(restaurantId);
        return Right(menu.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItemsByCategory({
    required String restaurantId,
    required String categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getMenuItemsByCategory(
          restaurantId: restaurantId,
          categoryId: categoryId,
        );
        return Right(items.map((item) => item.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, MenuItemEntity>> getMenuItemById({
    required String restaurantId,
    required String itemId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final item = await remoteDataSource.getMenuItemById(
          restaurantId: restaurantId,
          itemId: itemId,
        );
        return Right(item.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<MenuItemEntity>>> searchMenuItems({
    required String restaurantId,
    required String query,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.searchMenuItems(
          restaurantId: restaurantId,
          query: query,
        );
        return Right(items.map((item) => item.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<MenuItemEntity>>> getPopularItems(String restaurantId) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getPopularItems(restaurantId);
        return Right(items.map((item) => item.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<MenuItemEntity>>> getRecommendedItems(String restaurantId) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getRecommendedItems(restaurantId);
        return Right(items.map((item) => item.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
