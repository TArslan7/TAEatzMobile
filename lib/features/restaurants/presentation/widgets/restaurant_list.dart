import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../bloc/restaurant_bloc.dart';
import '../bloc/restaurant_state.dart';
import 'restaurant_card.dart';
import 'restaurant_loading_shimmer.dart';

class RestaurantList extends StatelessWidget {
  final List<RestaurantEntity> restaurants;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Function(RestaurantEntity)? onRestaurantTap;
  final Function(RestaurantEntity)? onFavoriteTap;
  final Map<String, bool> favorites;

  const RestaurantList({
    super.key,
    required this.restaurants,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onRestaurantTap,
    this.onFavoriteTap,
    this.favorites = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && restaurants.isEmpty) {
      return const RestaurantLoadingShimmer();
    }

    if (errorMessage != null && restaurants.isEmpty) {
      return _buildErrorWidget(context);
    }

    if (restaurants.isEmpty) {
      return _buildEmptyWidget(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: restaurants.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < restaurants.length) {
          final restaurant = restaurants[index];
          return RestaurantCard(
            restaurant: restaurant,
            isFavorite: favorites[restaurant.id] ?? false,
            onTap: () => onRestaurantTap?.call(restaurant),
            onFavoriteTap: () => onFavoriteTap?.call(restaurant),
          );
        } else {
          // Loading indicator at the bottom
          return const Padding(
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
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
              'Oops! Something went wrong',
              style: AppTheme.heading5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              errorMessage ?? 'Unable to load restaurants',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingL),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 64,
              color: AppTheme.textTertiaryColor,
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              'No restaurants found',
              style: AppTheme.heading5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
