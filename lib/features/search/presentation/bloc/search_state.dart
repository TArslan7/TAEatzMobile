import 'package:equatable/equatable.dart';
import '../../domain/entities/search_result_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchResultsLoaded extends SearchState {
  final List<SearchResultEntity> results;
  final String query;
  final bool hasReachedMax;

  const SearchResultsLoaded({
    required this.results,
    required this.query,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [results, query, hasReachedMax];
}

class SearchSuggestionsLoaded extends SearchState {
  final List<String> suggestions;
  final String query;

  const SearchSuggestionsLoaded({
    required this.suggestions,
    required this.query,
  });

  @override
  List<Object?> get props => [suggestions, query];
}

class PopularSearchesLoaded extends SearchState {
  final List<String> popularSearches;

  const PopularSearchesLoaded({required this.popularSearches});

  @override
  List<Object?> get props => [popularSearches];
}

class SearchHistoryLoaded extends SearchState {
  final List<String> searchHistory;

  const SearchHistoryLoaded({required this.searchHistory});

  @override
  List<Object?> get props => [searchHistory];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SearchCleared extends SearchState {
  const SearchCleared();
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}
