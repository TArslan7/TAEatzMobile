import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  final String query;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final int? limit;

  const SearchSubmitted({
    required this.query,
    this.latitude,
    this.longitude,
    this.radius,
    this.limit,
  });

  @override
  List<Object?> get props => [query, latitude, longitude, radius, limit];
}

class SearchRestaurants extends SearchEvent {
  final String query;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final int? limit;

  const SearchRestaurants({
    required this.query,
    this.latitude,
    this.longitude,
    this.radius,
    this.limit,
  });

  @override
  List<Object?> get props => [query, latitude, longitude, radius, limit];
}

class SearchMenuItems extends SearchEvent {
  final String query;
  final String? restaurantId;
  final int? limit;

  const SearchMenuItems({
    required this.query,
    this.restaurantId,
    this.limit,
  });

  @override
  List<Object?> get props => [query, restaurantId, limit];
}

class GetSearchSuggestions extends SearchEvent {
  final String query;
  final int? limit;

  const GetSearchSuggestions({
    required this.query,
    this.limit,
  });

  @override
  List<Object?> get props => [query, limit];
}

class GetPopularSearches extends SearchEvent {
  final int? limit;

  const GetPopularSearches({this.limit});

  @override
  List<Object?> get props => [limit];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class ClearSearchHistory extends SearchEvent {
  const ClearSearchHistory();
}

class LoadSearchHistory extends SearchEvent {
  const LoadSearchHistory();
}

class SearchResultTapped extends SearchEvent {
  final String resultId;
  final String resultType;

  const SearchResultTapped({
    required this.resultId,
    required this.resultType,
  });

  @override
  List<Object?> get props => [resultId, resultType];
}
