import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_menu_by_restaurant_id.dart';
import '../../domain/usecases/get_menu_items_by_category.dart';
import '../../domain/usecases/search_menu_items.dart' as search_usecase;
import '../../domain/repositories/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuByRestaurantId getMenuByRestaurantId;
  final GetMenuItemsByCategory getMenuItemsByCategory;
  final search_usecase.SearchMenuItems searchMenuItems;
  final MenuRepository repository;

  MenuBloc({
    required this.getMenuByRestaurantId,
    required this.getMenuItemsByCategory,
    required this.searchMenuItems,
    required this.repository,
  }) : super(const MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
    on<LoadMenuItemsByCategory>(_onLoadMenuItemsByCategory);
    on<LoadMenuItemById>(_onLoadMenuItemById);
    on<SearchMenuItems>(_onSearchMenuItems);
    on<LoadPopularItems>(_onLoadPopularItems);
    on<LoadRecommendedItems>(_onLoadRecommendedItems);
    on<RefreshMenu>(_onRefreshMenu);
    on<ClearSearch>(_onClearSearch);
  }

  void _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    emit(const MenuLoading());
    
    final result = await getMenuByRestaurantId(event.restaurantId);
    
    result.fold(
      (failure) => emit(MenuError(message: failure.message)),
      (menu) => emit(MenuLoaded(menu: menu)),
    );
  }

  void _onLoadMenuItemsByCategory(LoadMenuItemsByCategory event, Emitter<MenuState> emit) async {
    emit(const MenuLoading());
    
    final result = await getMenuItemsByCategory(
      restaurantId: event.restaurantId,
      categoryId: event.categoryId,
    );
    
    result.fold(
      (failure) => emit(MenuError(message: failure.message)),
      (items) => emit(MenuItemsLoaded(
        items: items,
        categoryId: event.categoryId,
      )),
    );
  }

  void _onLoadMenuItemById(LoadMenuItemById event, Emitter<MenuState> emit) async {
    emit(const MenuLoading());
    
    final result = await repository.getMenuItemById(
      restaurantId: event.restaurantId,
      itemId: event.itemId,
    );
    
    result.fold(
      (failure) => emit(MenuError(message: failure.message)),
      (item) => emit(MenuItemLoaded(item: item)),
    );
  }

  void _onSearchMenuItems(SearchMenuItems event, Emitter<MenuState> emit) async {
    emit(const MenuLoading());
    
    final result = await searchMenuItems(
      restaurantId: event.restaurantId,
      query: event.query,
    );
    
    result.fold(
      (failure) => emit(MenuError(message: failure.message)),
      (items) => emit(MenuSearchResultsLoaded(
        items: items,
        query: event.query,
      )),
    );
  }

  void _onLoadPopularItems(LoadPopularItems event, Emitter<MenuState> emit) async {
    emit(const MenuLoading());
    
    final result = await repository.getPopularItems(event.restaurantId);
    
    result.fold(
      (failure) => emit(MenuError(message: failure.message)),
      (items) => emit(PopularItemsLoaded(items: items)),
    );
  }

  void _onLoadRecommendedItems(LoadRecommendedItems event, Emitter<MenuState> emit) async {
    emit(const MenuLoading());
    
    final result = await repository.getRecommendedItems(event.restaurantId);
    
    result.fold(
      (failure) => emit(MenuError(message: failure.message)),
      (items) => emit(RecommendedItemsLoaded(items: items)),
    );
  }

  void _onRefreshMenu(RefreshMenu event, Emitter<MenuState> emit) async {
    add(LoadMenu(restaurantId: event.restaurantId));
  }

  void _onClearSearch(ClearSearch event, Emitter<MenuState> emit) async {
    emit(const MenuSearchCleared());
  }
}
