import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/menu_entity.dart';

class MenuCategoryTab extends StatelessWidget {
  final MenuCategoryEntity category;
  final bool isSelected;
  final VoidCallback? onTap;

  const MenuCategoryTab({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
          ),
          boxShadow: isSelected ? AppTheme.shadowS : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.name,
              style: AppTheme.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (category.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                category.description,
                style: AppTheme.caption.copyWith(
                  color: isSelected ? Colors.white70 : AppTheme.textSecondaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${category.items.length} items',
              style: AppTheme.caption.copyWith(
                color: isSelected ? Colors.white70 : AppTheme.textTertiaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
