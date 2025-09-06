import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends RestaurantEvent {
  final double? latitude;
  final double? longitude;
  final double? radius;
  final String? category;
  final String? searchQuery;
  final int? page;
  final int? limit;

  const LoadRestaurants({
    this.latitude,
    this.longitude,
    this.radius,
    this.category,
    this.searchQuery,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    radius,
    category,
    searchQuery,
    page,
    limit,
  ];
}

class LoadRestaurantById extends RestaurantEvent {
  final String id;

  const LoadRestaurantById({required this.id});

  @override
  List<Object?> get props => [id];
}

class SearchRestaurants extends RestaurantEvent {
  final String query;
  final double? latitude;
  final double? longitude;
  final double? radius;

  const SearchRestaurants({
    required this.query,
    this.latitude,
    this.longitude,
    this.radius,
  });

  @override
  List<Object?> get props => [query, latitude, longitude, radius];
}

class LoadRestaurantsByCategory extends RestaurantEvent {
  final String category;
  final double? latitude;
  final double? longitude;
  final double? radius;

  const LoadRestaurantsByCategory({
    required this.category,
    this.latitude,
    this.longitude,
    this.radius,
  });

  @override
  List<Object?> get props => [category, latitude, longitude, radius];
}

class LoadNearbyRestaurants extends RestaurantEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const LoadNearbyRestaurants({
    required this.latitude,
    required this.longitude,
    this.radius = 10.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class LoadCategories extends RestaurantEvent {
  const LoadCategories();
}

class LoadCuisineTypes extends RestaurantEvent {
  const LoadCuisineTypes();
}

class RefreshRestaurants extends RestaurantEvent {
  const RefreshRestaurants();
}

class ClearSearch extends RestaurantEvent {
  const ClearSearch();
}
