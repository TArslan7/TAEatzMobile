import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../../menu/presentation/bloc/menu_bloc.dart';
import '../../../menu/presentation/bloc/menu_event.dart';
import '../../../menu/presentation/bloc/menu_state.dart';
import '../../../menu/presentation/widgets/menu_item_card.dart';
import '../../../menu/presentation/widgets/menu_category_tab.dart';

class RestaurantDetailPage extends StatefulWidget {
  final RestaurantEntity restaurant;

  const RestaurantDetailPage({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  Map<String, int> _cartItems = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load menu for this restaurant
    context.read<MenuBloc>().add(LoadMenu(restaurantId: widget.restaurant.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<MenuBloc>().add(SearchMenuItems(
        restaurantId: widget.restaurant.id,
        query: query,
      ));
    } else {
      context.read<MenuBloc>().add(const ClearSearch());
    }
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    
    context.read<MenuBloc>().add(LoadMenuItemsByCategory(
      restaurantId: widget.restaurant.id,
      categoryId: categoryId,
    ));
  }

  void _onAddToCart(String itemId) {
    setState(() {
      _cartItems[itemId] = (_cartItems[itemId] ?? 0) + 1;
    });
    
    context.showSnackBar('Added to cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.restaurant.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.restaurant.name,
                            style: AppTheme.heading4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.restaurant.description,
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Restaurant Info
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                children: [
                  // Rating and Delivery Info
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppTheme.accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.restaurant.rating.toStringAsFixed(1)} (${widget.restaurant.reviewCount})',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Icon(
                        Icons.access_time,
                        color: AppTheme.textSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.restaurant.deliveryTimeRange,
                        style: AppTheme.bodyMedium,
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Icon(
                        Icons.delivery_dining,
                        color: AppTheme.textSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.restaurant.formattedDeliveryFee,
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search menu items...',
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
                ],
              ),
            ),
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Menu'),
                Tab(text: 'Info'),
              ],
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMenuTab(),
                  _buildInfoTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _cartItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusL),
                  topRight: Radius.circular(AppTheme.radiusL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_cartItems.values.reduce((a, b) => a + b)} items',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'View Cart',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to cart
                      context.showSnackBar('Cart functionality coming soon!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildMenuTab() {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state is MenuLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MenuLoaded) {
          return Column(
            children: [
              // Categories
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                  itemCount: state.menu.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.menu.categories[index];
                    final isSelected = _selectedCategoryId == category.id;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spacingS),
                      child: MenuCategoryTab(
                        category: category,
                        isSelected: isSelected,
                        onTap: () => _onCategorySelected(category.id),
                      ),
                    );
                  },
                ),
              ),
              
              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  itemCount: state.menu.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.menu.categories[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: AppTheme.heading5,
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        ...category.items.map((item) => MenuItemCard(
                          item: item,
                          quantity: _cartItems[item.id] ?? 0,
                          onAddToCart: () => _onAddToCart(item.id),
                        )),
                        const SizedBox(height: AppTheme.spacingL),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is MenuError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.textTertiaryColor,
                ),
                const SizedBox(height: AppTheme.spacingL),
                Text(
                  'Unable to load menu',
                  style: AppTheme.heading5,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  state.message,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                ElevatedButton(
                  onPressed: () {
                    context.read<MenuBloc>().add(LoadMenu(restaurantId: widget.restaurant.id));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Details
          Text(
            'Restaurant Details',
            style: AppTheme.heading5,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildInfoRow(Icons.location_on, 'Address', widget.restaurant.fullAddress),
          _buildInfoRow(Icons.phone, 'Phone', widget.restaurant.phoneNumber),
          _buildInfoRow(Icons.email, 'Email', widget.restaurant.email),
          _buildInfoRow(Icons.web, 'Website', widget.restaurant.website),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Categories
          Text(
            'Categories',
            style: AppTheme.heading5,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Wrap(
            spacing: AppTheme.spacingS,
            runSpacing: AppTheme.spacingS,
            children: widget.restaurant.categories.map((category) => Chip(
              label: Text(category),
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            )).toList(),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Payment Methods
          Text(
            'Payment Methods',
            style: AppTheme.heading5,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Wrap(
            spacing: AppTheme.spacingS,
            runSpacing: AppTheme.spacingS,
            children: widget.restaurant.acceptedPaymentMethods.map((method) => Chip(
              label: Text(method),
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.textSecondaryColor,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
