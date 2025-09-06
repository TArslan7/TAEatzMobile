import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant_entity.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
}

class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();
}

class RestaurantLoaded extends RestaurantState {
  final List<RestaurantEntity> restaurants;
  final bool hasReachedMax;
  final String? currentCategory;
  final String? currentSearchQuery;

  const RestaurantLoaded({
    required this.restaurants,
    this.hasReachedMax = false,
    this.currentCategory,
    this.currentSearchQuery,
  });

  @override
  List<Object?> get props => [
    restaurants,
    hasReachedMax,
    currentCategory,
    currentSearchQuery,
  ];
}

class RestaurantDetailLoaded extends RestaurantState {
  final RestaurantEntity restaurant;

  const RestaurantDetailLoaded({required this.restaurant});

  @override
  List<Object?> get props => [restaurant];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CategoriesLoaded extends RestaurantState {
  final List<String> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CuisineTypesLoaded extends RestaurantState {
  final List<String> cuisineTypes;

  const CuisineTypesLoaded({required this.cuisineTypes});

  @override
  List<Object?> get props => [cuisineTypes];
}

class SearchResultsLoaded extends RestaurantState {
  final List<RestaurantEntity> restaurants;
  final String query;

  const SearchResultsLoaded({
    required this.restaurants,
    required this.query,
  });

  @override
  List<Object?> get props => [restaurants, query];
}

class SearchCleared extends RestaurantState {
  const SearchCleared();
}
