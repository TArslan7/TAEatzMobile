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

class ImprovedHomeTab extends StatefulWidget {
  const ImprovedHomeTab({super.key});

  @override
  State<ImprovedHomeTab> createState() => _ImprovedHomeTabState();
}

class _ImprovedHomeTabState extends State<ImprovedHomeTab>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  final Map<String, bool> _favorites = {};
  LocationEntity? _selectedLocation;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _eatDrinkController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _eatDrinkAnimation;

  // Function to get time-based greeting
  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return 'Good morning! 🌅';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon! ☀️';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening! 🌆';
    } else {
      return 'Good night! 🌙';
    }
  }

  // Open location selection page
  void _openLocationSelection() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationSelectionPage(
          currentLocation: _selectedLocation,
        ),
      ),
    );
    
    if (result != null && result is LocationEntity) {
      setState(() {
        _selectedLocation = result;
      });
      // TODO: Save selected location to preferences
      // TODO: Reload restaurants based on location
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
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
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    
    _eatDrinkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _eatDrinkController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _eatDrinkController.repeat(reverse: true);
    
    // Load initial data
    context.read<RestaurantBloc>().add(const LoadRestaurants());
    context.read<RestaurantBloc>().add(const LoadCategories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _eatDrinkController.dispose();
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RestaurantDetailPage(restaurant: restaurant),
      ),
    );
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
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          body: Column(
            children: [
              // Fixed Location Header
              _buildFixedLocationHeader(themeManager),
              
              // Scrollable Content
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Modern App Bar with Dynamic Gradient
                    _buildModernAppBar(themeManager),
                    
                    // Hero Search Section
                    _buildHeroSearchSection(themeManager),
                    
                    // Quick Stats Cards
                    _buildQuickStatsSection(themeManager),
                    
                    // Categories with Enhanced Design
                    _buildEnhancedCategoriesSection(themeManager),
                    
                    // Featured Restaurants with Modern Cards
                    _buildFeaturedRestaurantsSection(themeManager),
                    
                    // Bottom Spacing
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fixed Location Header - Always visible at top
  Widget _buildFixedLocationHeader(ThemeManager themeManager) {
    return Container(
      color: themeManager.primaryRed,
      child: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: _openLocationSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 18,
                  color: themeManager.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _selectedLocation?.displayAddress ?? 'Select location',
                    style: TextStyle(
                      color: themeManager.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: themeManager.textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modern App Bar with Gradient Background
  Widget _buildModernAppBar(ThemeManager themeManager) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: themeManager.primaryRed,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: Text(
                                      _getTimeBasedGreeting(),
                                      style: TextStyle(
                                        color: themeManager.textColor.withOpacity(0.7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: AnimatedBuilder(
                                      animation: _eatDrinkAnimation,
                                      builder: (context, child) {
                                        final isEat = _eatDrinkAnimation.value < 0.5;
                                        final text = isEat ? 'eat' : 'drink';
                                        final emoji = isEat ? '🍽️' : '🥤';
                                        
                                        // Smooth transition effect
                                        final fadeValue = isEat 
                                            ? (1.0 - (_eatDrinkAnimation.value * 2)).clamp(0.0, 1.0)
                                            : ((_eatDrinkAnimation.value - 0.5) * 2).clamp(0.0, 1.0);
                                        
                                        return AnimatedOpacity(
                                          opacity: fadeValue,
                                          duration: const Duration(milliseconds: 500),
                                          child: AnimatedSlide(
                                            offset: Offset(0, isEat ? 0.0 : 0.1),
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                            child: Text(
                                              'What would you like\nto $text today? $emoji',
                                              style: TextStyle(
                                                color: themeManager.textColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButton(
                                icon: Icons.brightness_6_outlined,
                                onTap: () => themeManager.toggleTheme(),
                                themeManager: themeManager,
                              ),
                              const SizedBox(width: 4),
                              _buildActionButton(
                                icon: Icons.notifications_outlined,
                                onTap: () {},
                                badge: true,
                                themeManager: themeManager,
                              ),
                              const SizedBox(width: 4),
                              _buildActionButton(
                                icon: Icons.shopping_cart_outlined,
                                onTap: () {},
                                badge: true,
                                themeManager: themeManager,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hero Search Section
  Widget _buildHeroSearchSection(ThemeManager themeManager) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                _buildModernSearchBar(themeManager),
                const SizedBox(height: 12),
                _buildQuickActions(themeManager),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Quick Stats Section
  Widget _buildQuickStatsSection(ThemeManager themeManager) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.delivery_dining,
                    title: 'Fast Delivery',
                    subtitle: '15-30 min',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.star,
                    title: '4.8 Rating',
                    subtitle: 'Based on 2.5k+ reviews',
                    color: const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.restaurant,
                    title: '200+ Restaurants',
                    subtitle: 'Near you',
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Categories Section
  Widget _buildEnhancedCategoriesSection(ThemeManager themeManager) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildEnhancedCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Featured Restaurants Section
  Widget _buildFeaturedRestaurantsSection(ThemeManager themeManager) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Restaurants',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRestaurantList(themeManager),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Action Button with Badge
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool badge = false,
    ThemeManager? themeManager,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: (themeManager?.textColor ?? Colors.white).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (themeManager?.textColor ?? Colors.white).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                color: themeManager?.textColor ?? Colors.white,
                size: 16,
              ),
            ),
            if (badge)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5722),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Modern Search Bar
  Widget _buildModernSearchBar(ThemeManager themeManager) {
    return Container(
      decoration: BoxDecoration(
        color: themeManager.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: themeManager.textColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search for restaurants or dishes...',
          hintStyle: TextStyle(
            color: themeManager.textColor.withOpacity(0.6),
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              color: Color(0xFFDC2626),
              size: 20,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Color(0xFF9CA3AF),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.tune,
                    color: Color(0xFF9CA3AF),
                  ),
                  onPressed: () {},
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
        onSubmitted: _onSearch,
        onChanged: (value) {
          if (value.isEmpty) {
            _onSearch('');
          }
        },
      ),
    );
  }

  // Quick Actions
  Widget _buildQuickActions(ThemeManager themeManager) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.location_on,
            title: 'Nearby',
            color: const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.timer,
            title: 'Fastest',
            color: const Color(0xFFFF9800),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.star,
            title: 'Top Rated',
            color: const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  // Quick Action Button
  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Stat Card
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Categories
  Widget _buildEnhancedCategories() {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          _categories = state.categories;
        }
        
        if (_categories.isEmpty) {
          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildCategoryShimmer(),
                );
              },
            ),
          );
        }
        
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildEnhancedCategoryCard(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => _onCategorySelected(category),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Enhanced Category Card
  Widget _buildEnhancedCategoryCard({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = [
      const Color(0xFFDC2626), // Red
      const Color(0xFF991B1B), // Dark red
      const Color(0xFFEF4444), // Light red
      const Color(0xFFB91C1C), // Darker red
      const Color(0xFFF87171), // Lighter red
      const Color(0xFF7F1D1D), // Very dark red
    ];
    final color = colors[category.hashCode % colors.length];
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(category),
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Category Shimmer
  Widget _buildCategoryShimmer() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  // Get Category Icon
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

  // Restaurant List
  Widget _buildRestaurantList(ThemeManager themeManager) {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoading) {
          return Column(
            children: List.generate(3, (index) => _buildRestaurantShimmer()),
          );
        } else if (state is RestaurantLoaded) {
          return Column(
            children: state.restaurants.take(5).map((restaurant) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildModernRestaurantCard(
                  restaurant: restaurant,
                  isFavorite: _favorites[restaurant.id] ?? false,
                  onTap: () => _onRestaurantTap(restaurant),
                  onFavoriteTap: () => _onFavoriteTap(restaurant),
                  themeManager: themeManager,
                ),
              );
            }).toList(),
          );
        } else if (state is SearchResultsLoaded) {
          return Column(
            children: state.restaurants.take(5).map((restaurant) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildModernRestaurantCard(
                  restaurant: restaurant,
                  isFavorite: _favorites[restaurant.id] ?? false,
                  onTap: () => _onRestaurantTap(restaurant),
                  onFavoriteTap: () => _onFavoriteTap(restaurant),
                  themeManager: themeManager,
                ),
              );
            }).toList(),
          );
        } else if (state is RestaurantError) {
          return _buildErrorState(state.message);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  // Modern Restaurant Card
  Widget _buildModernRestaurantCard({
    required restaurant,
    required bool isFavorite,
    required VoidCallback onTap,
    required VoidCallback onFavoriteTap,
    ThemeManager? themeManager,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: themeManager?.primaryRed ?? Colors.red,
              ),
              child: Stack(
                children: [
                  // Restaurant Image Placeholder
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: (themeManager?.primaryRed ?? Colors.red).withOpacity(0.3),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Rating Badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFF9800),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name ?? 'Restaurant Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisineType ?? 'Cuisine Type',
                    style: TextStyle(
                      fontSize: 12,
                      color: (themeManager?.textColor ?? Colors.grey).withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${(restaurant.distance ?? 0.5).toStringAsFixed(1)} km away',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '15-30 min',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Restaurant Shimmer
  Widget _buildRestaurantShimmer() {
    return Container(
      height: 280,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  // Error State
  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}
