import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/menu_entity.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItemEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final int quantity;

  const MenuItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onAddToCart,
    this.quantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Item Image
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
                    imageUrl: item.imageUrl ?? item.imageUrls.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingM),
              
              // Item Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text(
                      item.name,
                      style: AppTheme.heading6,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    // Item Description
                    Text(
                      item.description,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    // Dietary Info
                    if (item.dietaryInfo.isNotEmpty)
                      Wrap(
                        spacing: AppTheme.spacingXS,
                        children: item.dietaryInfo.take(3).map((info) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingXS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          ),
                          child: Text(
                            info,
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )).toList(),
                      ),
                    
                    const SizedBox(height: AppTheme.spacingXS),
                    
                    // Price and Info
                    Row(
                      children: [
                        Text(
                          item.formattedPrice,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(width: AppTheme.spacingM),
                        
                        if (item.calories > 0)
                          Text(
                            item.caloriesText,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textTertiaryColor,
                            ),
                          ),
                        
                        const SizedBox(width: AppTheme.spacingM),
                        
                        Text(
                          item.preparationTimeText,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textTertiaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add to Cart Button
              Column(
                children: [
                  if (quantity > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        quantity.toString(),
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                  ],
                  
                  IconButton(
                    onPressed: onAddToCart,
                    icon: Icon(
                      quantity > 0 ? Icons.add_circle : Icons.add_circle_outline,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
