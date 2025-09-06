import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_entity.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final MenuEntity menu;
  final String? selectedCategoryId;

  const MenuLoaded({
    required this.menu,
    this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [menu, selectedCategoryId];
}

class MenuItemsLoaded extends MenuState {
  final List<MenuItemEntity> items;
  final String categoryId;

  const MenuItemsLoaded({
    required this.items,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [items, categoryId];
}

class MenuItemLoaded extends MenuState {
  final MenuItemEntity item;

  const MenuItemLoaded({required this.item});

  @override
  List<Object?> get props => [item];
}

class MenuSearchResultsLoaded extends MenuState {
  final List<MenuItemEntity> items;
  final String query;

  const MenuSearchResultsLoaded({
    required this.items,
    required this.query,
  });

  @override
  List<Object?> get props => [items, query];
}

class PopularItemsLoaded extends MenuState {
  final List<MenuItemEntity> items;

  const PopularItemsLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class RecommendedItemsLoaded extends MenuState {
  final List<MenuItemEntity> items;

  const RecommendedItemsLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class MenuError extends MenuState {
  final String message;

  const MenuError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MenuSearchCleared extends MenuState {
  const MenuSearchCleared();
}
