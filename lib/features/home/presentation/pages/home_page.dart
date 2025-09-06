import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../restaurants/presentation/bloc/restaurant_bloc.dart';
import '../../../restaurants/presentation/bloc/restaurant_event.dart';
import '../../../restaurants/presentation/bloc/restaurant_state.dart';
import '../../../restaurants/presentation/widgets/restaurant_card.dart';
import '../../../restaurants/presentation/widgets/category_chip.dart';
import '../../../restaurants/presentation/widgets/restaurant_loading_shimmer.dart';
import '../../../restaurants/presentation/pages/restaurant_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const SearchTab(),
    const OrdersTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textTertiaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  Map<String, bool> _favorites = {};

  @override
  void initState() {
    super.initState();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning!',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            Text(
              'What would you like to eat?',
              style: AppTheme.heading5,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                boxShadow: AppTheme.shadowS,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for restaurants or dishes...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () {
                            // TODO: Open filters
                          },
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingM,
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
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Categories
            Text(
              'Categories',
              style: AppTheme.heading5,
            ),
            const SizedBox(height: AppTheme.spacingM),
            BlocBuilder<RestaurantBloc, RestaurantState>(
              builder: (context, state) {
                if (state is CategoriesLoaded) {
                  _categories = state.categories;
                }
                
                if (_categories.isNotEmpty) {
                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
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
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Featured Restaurants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Restaurants',
                  style: AppTheme.heading5,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all restaurants
                  },
                  child: Text(
                    'See All',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Restaurant Cards
            BlocBuilder<RestaurantBloc, RestaurantState>(
              builder: (context, state) {
                if (state is RestaurantLoading) {
                  return const RestaurantLoadingShimmer(itemCount: 3);
                } else if (state is RestaurantLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.restaurants.take(5).length,
                    itemBuilder: (context, index) {
                      final restaurant = state.restaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        isFavorite: _favorites[restaurant.id] ?? false,
                        onTap: () => _onRestaurantTap(restaurant),
                        onFavoriteTap: () => _onFavoriteTap(restaurant),
                      );
                    },
                  );
                } else if (state is SearchResultsLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.restaurants.take(5).length,
                    itemBuilder: (context, index) {
                      final restaurant = state.restaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        isFavorite: _favorites[restaurant.id] ?? false,
                        onTap: () => _onRestaurantTap(restaurant),
                        onFavoriteTap: () => _onFavoriteTap(restaurant),
                      );
                    },
                  );
                } else if (state is RestaurantError) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppTheme.textTertiaryColor,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        Text(
                          'Unable to load restaurants',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RestaurantBloc>().add(const LoadRestaurants());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return Icons.local_pizza;
      case 'burgers':
        return Icons.lunch_dining;
      case 'sushi':
        return Icons.set_meal;
      case 'chinese':
        return Icons.ramen_dining;
      case 'italian':
        return Icons.restaurant;
      case 'mexican':
        return Icons.restaurant;
      case 'indian':
        return Icons.restaurant;
      case 'thai':
        return Icons.emoji_food_beverage;
      case 'fast food':
        return Icons.fastfood;
      case 'desserts':
        return Icons.cake;
      case 'healthy':
        return Icons.eco;
      case 'vegetarian':
        return Icons.restaurant;
      case 'vegan':
        return Icons.park;
      case 'halal':
        return Icons.mosque;
      case 'kosher':
        return Icons.temple_buddhist;
      default:
        return Icons.restaurant;
    }
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for restaurants or dishes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    // TODO: Open filters
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                ),
              ),
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Search functionality coming soon!'),
      ),
    );
  }
}

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: const Center(
        child: Text('Order history coming soon!'),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Profile page coming soon!'),
      ),
    );
  }
}
