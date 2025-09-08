import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/restaurant_entity.dart';

class ImprovedRestaurantCard extends StatefulWidget {
  final RestaurantEntity restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const ImprovedRestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  State<ImprovedRestaurantCard> createState() => _ImprovedRestaurantCardState();
}

class _ImprovedRestaurantCardState extends State<ImprovedRestaurantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: _elevationAnimation.value,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.borderColor.withOpacity(0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Row(
                        children: [
                          // Restaurant Image
                          _buildRestaurantImage(),
                          const SizedBox(width: AppTheme.spacingM),
                          // Restaurant Info
                          Expanded(
                            child: _buildRestaurantInfo(),
                          ),
                          // Favorite Button
                          _buildFavoriteButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        color: AppTheme.backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: CachedNetworkImage(
          imageUrl: widget.restaurant.imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppTheme.backgroundColor,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppTheme.backgroundColor,
            child: Icon(
              Icons.restaurant,
              size: 32,
              color: AppTheme.textTertiaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Restaurant Name
        Text(
          widget.restaurant.name,
          style: AppTheme.heading6,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppTheme.spacingXS),
        // Description
        Text(
          widget.restaurant.description,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppTheme.spacingS),
        // Rating and Delivery Info
        Row(
          children: [
            // Rating
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: AppTheme.warningColor,
                ),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  widget.restaurant.rating.toStringAsFixed(1),
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppTheme.spacingM),
            // Delivery Time
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppTheme.textTertiaryColor,
                ),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  '${widget.restaurant.deliveryTimeMin}-${widget.restaurant.deliveryTimeMax} min',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Price Range
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingS,
                vertical: AppTheme.spacingXS,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Text(
                '€${widget.restaurant.deliveryFee.toStringAsFixed(0)}',
                style: AppTheme.caption.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingS),
        // Categories
        if (widget.restaurant.categories.isNotEmpty)
          Wrap(
            spacing: AppTheme.spacingXS,
            runSpacing: AppTheme.spacingXS,
            children: widget.restaurant.categories.take(2).map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Text(
                  category,
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: widget.onFavoriteTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.isFavorite 
              ? AppTheme.primaryColor.withOpacity(0.1)
              : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: Border.all(
            color: widget.isFavorite 
                ? AppTheme.primaryColor
                : AppTheme.borderColor,
          ),
        ),
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? AppTheme.primaryColor : AppTheme.textTertiaryColor,
          size: 20,
        ),
      ),
    );
  }
}
