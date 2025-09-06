import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../bloc/restaurant_bloc.dart';
import '../bloc/restaurant_event.dart';
import '../bloc/restaurant_state.dart';
import '../widgets/restaurant_list.dart';
import '../widgets/category_chip.dart';

class RestaurantsPage extends StatefulWidget {
  final String? category;
  final String? searchQuery;

  const RestaurantsPage({
    super.key,
    this.category,
    this.searchQuery,
  });

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  Map<String, bool> _favorites = {};

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _searchController.text = widget.searchQuery ?? '';
    
    // Load initial data
    context.read<RestaurantBloc>().add(const LoadRestaurants());
    context.read<RestaurantBloc>().add(const LoadCategories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<RestaurantBloc>().add(SearchRestaurants(query: query));
    } else {
      context.read<RestaurantBloc>().add(const ClearSearch());
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
    });
    
    context.read<RestaurantBloc>().add(LoadRestaurantsByCategory(
      category: _selectedCategory ?? '',
    ));
  }

  void _onRestaurantTap(restaurant) {
    // TODO: Navigate to restaurant detail page
    context.showSnackBar('Restaurant detail page coming soon!');
  }

  void _onFavoriteTap(restaurant) {
    setState(() {
      _favorites[restaurant.id] = !(_favorites[restaurant.id] ?? false);
    });
    
    // TODO: Save favorite to backend
    context.showSnackBar(
      _favorites[restaurant.id] == true 
        ? 'Added to favorites' 
        : 'Removed from favorites'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category != null 
            ? '${widget.category} Restaurants'
            : 'Restaurants',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                ),
              ),
              onSubmitted: _onSearch,
              onChanged: (value) {
                if (value.isEmpty) {
                  _onSearch('');
                }
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Categories
          BlocBuilder<RestaurantBloc, RestaurantState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                _categories = state.categories;
              }
              
              if (_categories.isNotEmpty) {
                return Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: AppTheme.spacingS),
                        child: CategoryChip(
                          category: category,
                          isSelected: isSelected,
                          onTap: () => _onCategorySelected(category),
                        ),
                      );
                    },
                  ),
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
          
          // Restaurant List
          Expanded(
            child: BlocBuilder<RestaurantBloc, RestaurantState>(
              builder: (context, state) {
                if (state is RestaurantLoading) {
                  return const RestaurantList(
                    restaurants: [],
                    isLoading: true,
                  );
                } else if (state is RestaurantLoaded) {
                  return RestaurantList(
                    restaurants: state.restaurants,
                    favorites: _favorites,
                    onRestaurantTap: _onRestaurantTap,
                    onFavoriteTap: _onFavoriteTap,
                    onRetry: () {
                      context.read<RestaurantBloc>().add(const LoadRestaurants());
                    },
                  );
                } else if (state is SearchResultsLoaded) {
                  return RestaurantList(
                    restaurants: state.restaurants,
                    favorites: _favorites,
                    onRestaurantTap: _onRestaurantTap,
                    onFavoriteTap: _onFavoriteTap,
                    onRetry: () {
                      _onSearch(_searchController.text);
                    },
                  );
                } else if (state is RestaurantError) {
                  return RestaurantList(
                    restaurants: [],
                    errorMessage: state.message,
                    onRetry: () {
                      context.read<RestaurantBloc>().add(const LoadRestaurants());
                    },
                  );
                } else if (state is SearchCleared) {
                  return RestaurantList(
                    restaurants: [],
                    onRetry: () {
                      context.read<RestaurantBloc>().add(const LoadRestaurants());
                    },
                  );
                }
                
                return const RestaurantList(restaurants: []);
              },
            ),
          ),
        ],
      ),
    );
  }
}
