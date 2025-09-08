import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/cart_entity.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;
  final Function(String?)? onSpecialInstructionsChanged;

  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
    this.onSpecialInstructionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Item Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    color: AppTheme.primaryColor.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.fastfood,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.fastfood,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppTheme.spacingM),
                
                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTheme.heading6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: AppTheme.spacingXS),
                      
                      Text(
                        item.description,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: AppTheme.spacingXS),
                      
                      // Selected Options
                      if (item.selectedOptions.isNotEmpty) ...[
                        Wrap(
                          spacing: AppTheme.spacingXS,
                          runSpacing: AppTheme.spacingXS,
                          children: item.selectedOptions.map((option) => Chip(
                            label: Text(
                              '${option.name}: ${option.value}',
                              style: AppTheme.bodySmall,
                            ),
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            labelStyle: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                      ],
                      
                      // Price
                      Text(
                        item.formattedTotalPrice,
                        style: AppTheme.heading6.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Quantity Controls
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: onDecrement,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppTheme.primaryColor,
                        ),
                        Text(
                          '${item.quantity}',
                          style: AppTheme.heading6,
                        ),
                        IconButton(
                          onPressed: onIncrement,
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline),
                      color: AppTheme.errorColor,
                    ),
                  ],
                ),
              ],
            ),
            
            // Special Instructions
            if (onSpecialInstructionsChanged != null) ...[
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Special Instructions',
                  hintText: 'Any special requests?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: onSpecialInstructionsChanged,
                controller: TextEditingController(text: item.specialInstructions ?? ''),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


