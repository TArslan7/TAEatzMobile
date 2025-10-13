import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../restaurants/presentation/bloc/restaurant_bloc.dart';
import '../../../restaurants/presentation/bloc/restaurant_state.dart';

class HomeCategoriesSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final List<String> categories;

  const HomeCategoriesSection({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeManager.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoriesList(themeManager),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesList(ThemeManager themeManager) {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (categories.isEmpty) {
          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildCategoryShimmer(themeManager),
                );
              },
            ),
          );
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildCategoryCard(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(category),
                  themeManager: themeManager,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeManager themeManager,
  }) {
    final colors = [
      const Color(0xFFDC2626),
      const Color(0xFF991B1B),
      const Color(0xFFEF4444),
      const Color(0xFFB91C1C),
      const Color(0xFFF87171),
      const Color(0xFF7F1D1D),
    ];
    final color = colors[category.hashCode % colors.length];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? color : themeManager.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : themeManager.shadowColor.withOpacity(0.15),
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
                color: themeManager.textColor,
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

  Widget _buildCategoryShimmer(ThemeManager themeManager) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: themeManager.cardColor,
        borderRadius: BorderRadius.circular(20),
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

