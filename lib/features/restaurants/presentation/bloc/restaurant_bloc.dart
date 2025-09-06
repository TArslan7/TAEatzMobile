import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../../domain/usecases/get_restaurant_by_id.dart';
import '../../domain/usecases/search_restaurants.dart' as search_usecase;
import '../../domain/repositories/restaurant_repository.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurants getRestaurants;
  final GetRestaurantById getRestaurantById;
  final search_usecase.SearchRestaurants searchRestaurants;
  final RestaurantRepository repository;

  RestaurantBloc({
    required this.getRestaurants,
    required this.getRestaurantById,
    required this.searchRestaurants,
    required this.repository,
  }) : super(const RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<LoadRestaurantById>(_onLoadRestaurantById);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<LoadRestaurantsByCategory>(_onLoadRestaurantsByCategory);
    on<LoadNearbyRestaurants>(_onLoadNearbyRestaurants);
    on<LoadCategories>(_onLoadCategories);
    on<LoadCuisineTypes>(_onLoadCuisineTypes);
    on<RefreshRestaurants>(_onRefreshRestaurants);
    on<ClearSearch>(_onClearSearch);
  }

  void _onLoadRestaurants(LoadRestaurants event, Emitter<RestaurantState> emit) async {
    emit(const RestaurantLoading());
    
    final result = await getRestaurants(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      category: event.category,
      searchQuery: event.searchQuery,
      page: event.page,
      limit: event.limit,
    );
    
    result.fold(
      (failure) => emit(RestaurantError(message: failure.message)),
      (restaurants) => emit(RestaurantLoaded(
        restaurants: restaurants,
        currentCategory: event.category,
        currentSearchQuery: event.searchQuery,
      )),
    );
  }

  void _onLoadRestaurantById(LoadRestaurantById event, Emitter<RestaurantState> emit) async {
    emit(const RestaurantLoading());
    
    final result = await getRestaurantById(event.id);
    
    result.fold(
      (failure) => emit(RestaurantError(message: failure.message)),
      (restaurant) => emit(RestaurantDetailLoaded(restaurant: restaurant)),
    );
  }

  void _onSearchRestaurants(SearchRestaurants event, Emitter<RestaurantState> emit) async {
    emit(const RestaurantLoading());
    
    final result = await searchRestaurants(
      query: event.query,
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
    );
    
    result.fold(
      (failure) => emit(RestaurantError(message: failure.message)),
      (restaurants) => emit(SearchResultsLoaded(
        restaurants: restaurants,
        query: event.query,
      )),
    );
  }

  void _onLoadRestaurantsByCategory(LoadRestaurantsByCategory event, Emitter<RestaurantState> emit) async {
    emit(const RestaurantLoading());
    
    final result = await getRestaurants(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      category: event.category,
    );
    
    result.fold(
      (failure) => emit(RestaurantError(message: failure.message)),
      (restaurants) => emit(RestaurantLoaded(
        restaurants: restaurants,
        currentCategory: event.category,
      )),
    );
  }

  void _onLoadNearbyRestaurants(LoadNearbyRestaurants event, Emitter<RestaurantState> emit) async {
    emit(const RestaurantLoading());
    
    final result = await getRestaurants(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
    );
    
    result.fold(
      (failure) => emit(RestaurantError(message: failure.message)),
      (restaurants) => emit(RestaurantLoaded(restaurants: restaurants)),
    );
  }

  void _onLoadCategories(LoadCategories event, Emitter<RestaurantState> emit) async {
    final result = await repository.getRestaurantCategories();
    
    result.fold(
      (failure) => emit(RestaurantError(message: failure.message)),
      (categories) => emit(CategoriesLoaded(categories: categories)),
    );
  }

  void _onLoadCuisineTypes(LoadCuisineTypes event, Emitter<RestaurantState> emit) async {
    final result = await repository.getCuisineTypes();
    
    result.fold(
      (failure) => emit(RestaurantError(message: failure.message)),
      (cuisineTypes) => emit(CuisineTypesLoaded(cuisineTypes: cuisineTypes)),
    );
  }

  void _onRefreshRestaurants(RefreshRestaurants event, Emitter<RestaurantState> emit) async {
    // Reload restaurants with current parameters
    if (state is RestaurantLoaded) {
      final currentState = state as RestaurantLoaded;
      add(LoadRestaurants(
        category: currentState.currentCategory,
        searchQuery: currentState.currentSearchQuery,
      ));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<RestaurantState> emit) async {
    emit(const SearchCleared());
    // Reload all restaurants
    add(const LoadRestaurants());
  }
}
