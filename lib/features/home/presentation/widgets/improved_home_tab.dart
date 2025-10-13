import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../../../restaurants/presentation/bloc/restaurant_bloc.dart';
import '../../../restaurants/presentation/bloc/restaurant_event.dart';
import '../../../restaurants/presentation/bloc/restaurant_state.dart';
import '../../../restaurants/presentation/pages/restaurant_detail_page.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../../location/presentation/pages/location_selection_page.dart';
import 'home_location_header.dart';
import 'home_greeting_section.dart';
import 'home_search_section.dart';
import 'home_stats_section.dart';
import 'home_categories_section.dart';
import 'home_restaurants_section.dart';

class ImprovedHomeTab extends StatefulWidget {
  const ImprovedHomeTab({super.key});

  @override
  State<ImprovedHomeTab> createState() => _ImprovedHomeTabState();
}

class _ImprovedHomeTabState extends State<ImprovedHomeTab>
    with TickerProviderStateMixin {
  // Controllers & State
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  final Map<String, bool> _favorites = {};
  LocationEntity? _selectedLocation;
  bool _isDeliveryMode = true;

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _eatDrinkController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _eatDrinkAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _eatDrinkController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _eatDrinkController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _eatDrinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _eatDrinkController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _eatDrinkController.repeat(reverse: true);
  }

  void _loadInitialData() {
    context.read<RestaurantBloc>().add(const LoadRestaurants());
    context.read<RestaurantBloc>().add(const LoadCategories());
  }

  Future<void> _refreshHomeScreen() async {
    // Trigger refresh with animation
    context.read<RestaurantBloc>().add(const LoadRestaurants());
    context.read<RestaurantBloc>().add(const LoadCategories());
    
    // Wait for data to load
    await Future.delayed(const Duration(milliseconds: 800));
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning! 🌅';
    if (hour >= 12 && hour < 17) return 'Good afternoon! ☀️';
    if (hour >= 17 && hour < 21) return 'Good evening! 🌆';
    return 'Good night! 🌙';
  }

  Future<void> _openLocationSelection() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationSelectionPage(
          currentLocation: _selectedLocation,
        ),
      ),
    );

    if (result != null && result is LocationEntity) {
      setState(() => _selectedLocation = result);
      // TODO: Save selected location and reload restaurants
    }
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
    context.read<RestaurantBloc>().add(
      LoadRestaurantsByCategory(category: _selectedCategory ?? ''),
    );
  }

  void _onRestaurantTap(dynamic restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RestaurantDetailPage(restaurant: restaurant),
      ),
    );
  }

  void _onFavoriteTap(dynamic restaurant) {
    setState(() {
      _favorites[restaurant.id] = !(_favorites[restaurant.id] ?? false);
    });
    context.showSnackBar(
      _favorites[restaurant.id] == true
          ? 'Added to favorites'
          : 'Removed from favorites',
    );
  }

  void _onModeChanged(bool isDelivery) {
    setState(() {
      _isDeliveryMode = isDelivery;
    });
    
    // Show feedback
    context.showSnackBar(
      isDelivery
          ? 'Switched to Delivery mode 🚴'
          : 'Switched to Takeaway mode 🛍️',
    );
    
    // TODO: Filter restaurants based on delivery/takeaway availability
    // TODO: Update pricing based on mode (no delivery fee for takeaway)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return BlocListener<RestaurantBloc, RestaurantState>(
          listener: (context, state) {
            if (state is CategoriesLoaded) {
              setState(() => _categories = state.categories);
            }
          },
          child: Scaffold(
            backgroundColor: themeManager.backgroundColor,
            body: Column(
              children: [
                // Fixed Location Header (Always visible)
                HomeLocationHeader(
                  themeManager: themeManager,
                  selectedLocation: _selectedLocation,
                  onTap: _openLocationSelection,
                  isDeliveryMode: _isDeliveryMode,
                  onModeChanged: _onModeChanged,
                ),

                // Scrollable Content with Pull-to-Refresh
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshHomeScreen,
                    color: themeManager.primaryRed,
                    backgroundColor: themeManager.cardColor,
                    displacement: 40,
                    strokeWidth: 3,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        // Greeting Section
                        SliverToBoxAdapter(
                          child: HomeGreetingSection(
                            themeManager: themeManager,
                            fadeAnimation: _fadeAnimation,
                            slideAnimation: _slideAnimation,
                            eatDrinkAnimation: _eatDrinkAnimation,
                            getTimeBasedGreeting: _getTimeBasedGreeting,
                          ),
                        ),

                        // Search Section
                        SliverToBoxAdapter(
                          child: HomeSearchSection(
                            themeManager: themeManager,
                            searchController: _searchController,
                            onSearch: _onSearch,
                            fadeAnimation: _fadeAnimation,
                            slideAnimation: _slideAnimation,
                          ),
                        ),

                        // Quick Stats Section
                        SliverToBoxAdapter(
                          child: HomeStatsSection(
                            fadeAnimation: _fadeAnimation,
                            slideAnimation: _slideAnimation,
                          ),
                        ),

                        // Categories Section
                        SliverToBoxAdapter(
                          child: HomeCategoriesSection(
                            fadeAnimation: _fadeAnimation,
                            slideAnimation: _slideAnimation,
                            selectedCategory: _selectedCategory,
                            onCategorySelected: _onCategorySelected,
                            categories: _categories,
                          ),
                        ),

                        // Featured Restaurants Section
                        SliverToBoxAdapter(
                          child: HomeRestaurantsSection(
                            fadeAnimation: _fadeAnimation,
                            slideAnimation: _slideAnimation,
                            themeManager: themeManager,
                            favorites: _favorites,
                            onRestaurantTap: _onRestaurantTap,
                            onFavoriteTap: _onFavoriteTap,
                          ),
                        ),

                        // Bottom Spacing for navigation bar
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 100),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

