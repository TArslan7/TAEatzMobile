import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_all.dart';
import '../../domain/usecases/get_search_suggestions.dart' as suggestions_usecase;
import '../../domain/usecases/get_popular_searches.dart' as popular_usecase;
import '../../data/datasources/search_local_datasource.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../../../core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../../../main.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchAll searchAll;
  final suggestions_usecase.GetSearchSuggestions getSearchSuggestions;
  final popular_usecase.GetPopularSearches getPopularSearches;
  final SearchRepositoryImpl repository;

  SearchBloc({
    required this.searchAll,
    required this.getSearchSuggestions,
    required this.getPopularSearches,
    required this.repository,
  }) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<SearchMenuItems>(_onSearchMenuItems);
    on<GetSearchSuggestions>(_onGetSearchSuggestions);
    on<GetPopularSearches>(_onGetPopularSearches);
    on<ClearSearch>(_onClearSearch);
    on<ClearSearchHistory>(_onClearSearchHistory);
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<SearchResultTapped>(_onSearchResultTapped);
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    if (event.query.length >= 2) {
      add(GetSearchSuggestions(query: event.query, limit: 5));
    }
  }

  void _onSearchSubmitted(SearchSubmitted event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(const SearchEmpty(query: ''));
      return;
    }

    emit(const SearchLoading());

    final result = await searchAll(
      query: event.query,
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (results) {
        if (results.isEmpty) {
          emit(SearchEmpty(query: event.query));
        } else {
          emit(SearchResultsLoaded(
            results: results,
            query: event.query,
          ));
        }
      },
    );
  }

  void _onSearchRestaurants(SearchRestaurants event, Emitter<SearchState> emit) async {
    emit(const SearchLoading());

    final result = await repository.searchRestaurants(
      query: event.query,
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (results) {
        final searchResults = results.map((entity) => entity).toList();
        if (searchResults.isEmpty) {
          emit(SearchEmpty(query: event.query));
        } else {
          emit(SearchResultsLoaded(
            results: searchResults,
            query: event.query,
          ));
        }
      },
    );
  }

  void _onSearchMenuItems(SearchMenuItems event, Emitter<SearchState> emit) async {
    emit(const SearchLoading());

    final result = await repository.searchMenuItems(
      query: event.query,
      restaurantId: event.restaurantId,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (results) {
        final searchResults = results.map((entity) => entity).toList();
        if (searchResults.isEmpty) {
          emit(SearchEmpty(query: event.query));
        } else {
          emit(SearchResultsLoaded(
            results: searchResults,
            query: event.query,
          ));
        }
      },
    );
  }

  void _onGetSearchSuggestions(GetSearchSuggestions event, Emitter<SearchState> emit) async {
    final result = await getSearchSuggestions(
      query: event.query,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (suggestions) => emit(SearchSuggestionsLoaded(
        suggestions: suggestions,
        query: event.query,
      )),
    );
  }

  void _onGetPopularSearches(GetPopularSearches event, Emitter<SearchState> emit) async {
    final result = await getPopularSearches(limit: event.limit);

    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (popularSearches) => emit(PopularSearchesLoaded(
        popularSearches: popularSearches,
      )),
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(const SearchCleared());
  }

  void _onClearSearchHistory(ClearSearchHistory event, Emitter<SearchState> emit) async {
    try {
      await repository.localDataSource.clearSearchHistory();
      emit(const SearchHistoryLoaded(searchHistory: []));
    } catch (e) {
      emit(SearchError(message: 'Failed to clear search history'));
    }
  }

  void _onLoadSearchHistory(LoadSearchHistory event, Emitter<SearchState> emit) async {
    try {
      final history = await repository.localDataSource.getSearchHistory();
      emit(SearchHistoryLoaded(searchHistory: history));
    } catch (e) {
      emit(SearchError(message: 'Failed to load search history'));
    }
  }

  void _onSearchResultTapped(SearchResultTapped event, Emitter<SearchState> emit) {
    // Handle navigation based on result type
    // This would typically navigate to the appropriate page
  }
}

// Factory function to create SearchBloc with dependencies
SearchBloc createSearchBloc() {
  final dio = Dio();
  final remoteDataSource = SearchRemoteDataSourceImpl(
    dio: dio,
    baseUrl: 'https://api.taeatz.com',
  );
  final localDataSource = SearchLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );
  final networkInfo = NetworkInfoImpl(connectivity: Connectivity());
  final repository = SearchRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  return SearchBloc(
    searchAll: SearchAll(repository),
    getSearchSuggestions: suggestions_usecase.GetSearchSuggestions(repository),
    getPopularSearches: popular_usecase.GetPopularSearches(repository),
    repository: repository,
  );
}
