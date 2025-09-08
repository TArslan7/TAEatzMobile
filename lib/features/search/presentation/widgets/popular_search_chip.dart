import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PopularSearchChip extends StatelessWidget {
  final String searchTerm;
  final VoidCallback? onTap;

  const PopularSearchChip({
    super.key,
    required this.searchTerm,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusRound),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.trending_up,
              size: 16,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: AppTheme.spacingS),
            Text(
              searchTerm,
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
