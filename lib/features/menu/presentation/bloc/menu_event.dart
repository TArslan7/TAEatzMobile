import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenu extends MenuEvent {
  final String restaurantId;

  const LoadMenu({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}

class LoadMenuItemsByCategory extends MenuEvent {
  final String restaurantId;
  final String categoryId;

  const LoadMenuItemsByCategory({
    required this.restaurantId,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [restaurantId, categoryId];
}

class LoadMenuItemById extends MenuEvent {
  final String restaurantId;
  final String itemId;

  const LoadMenuItemById({
    required this.restaurantId,
    required this.itemId,
  });

  @override
  List<Object?> get props => [restaurantId, itemId];
}

class SearchMenuItems extends MenuEvent {
  final String restaurantId;
  final String query;

  const SearchMenuItems({
    required this.restaurantId,
    required this.query,
  });

  @override
  List<Object?> get props => [restaurantId, query];
}

class LoadPopularItems extends MenuEvent {
  final String restaurantId;

  const LoadPopularItems({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}

class LoadRecommendedItems extends MenuEvent {
  final String restaurantId;

  const LoadRecommendedItems({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}

class RefreshMenu extends MenuEvent {
  final String restaurantId;

  const RefreshMenu({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}

class ClearSearch extends MenuEvent {
  const ClearSearch();
}
