import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SearchSuggestionItem extends StatelessWidget {
  final String suggestion;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const SearchSuggestionItem({
    super.key,
    required this.suggestion,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        child: Row(
          children: [
            Icon(
              Icons.history,
              size: 16,
              color: AppTheme.textTertiaryColor,
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Text(
                suggestion,
                style: AppTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: onRemove,
                color: AppTheme.textTertiaryColor,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
