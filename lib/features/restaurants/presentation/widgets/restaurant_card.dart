import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../pages/restaurant_detail_page.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RestaurantDetailPage(restaurant: restaurant),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Restaurant Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  child: CachedNetworkImage(
                    imageUrl: restaurant.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.restaurant,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.restaurant,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingM),
              
              // Restaurant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name
                    Text(
                      restaurant.name,
                      style: AppTheme.heading6,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    // Categories
                    Text(
                      restaurant.categories.take(2).join(' • '),
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    // Rating and Delivery Time
                    Row(
                      children: [
                        // Rating
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: restaurant.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: AppTheme.accentColor,
                              ),
                              itemCount: 5,
                              itemSize: 12.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(width: AppTheme.spacingXS),
                            Text(
                              '${restaurant.rating.toStringAsFixed(1)} (${restaurant.reviewCount})',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(width: AppTheme.spacingM),
                        
                        // Delivery Time
                        Text(
                          restaurant.deliveryTimeRange,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    // Delivery Fee and Minimum Order
                    Row(
                      children: [
                        Text(
                          restaurant.formattedDeliveryFee,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(width: AppTheme.spacingM),
                        
                        Text(
                          'Min. ${restaurant.formattedMinimumOrder}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textTertiaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Favorite Button
              IconButton(
                onPressed: onFavoriteTap,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.primaryColor : AppTheme.textTertiaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
