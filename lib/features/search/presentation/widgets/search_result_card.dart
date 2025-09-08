import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/search_result_entity.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResultEntity result;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const SearchResultCard({
    super.key,
    required this.result,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppTheme.backgroundColor,
                  child: result.imageUrl != null
                      ? Image.network(
                          result.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholderIcon(),
                        )
                      : _buildPlaceholderIcon(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            result.title,
                            style: AppTheme.heading6,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        _buildTypeChip(),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    // Subtitle
                    Text(
                      result.subtitle,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    // Rating and Price
                    Row(
                      children: [
                        if (result.rating != null) ...[
                          Icon(
                            Icons.star,
                            size: 14,
                            color: AppTheme.warningColor,
                          ),
                          const SizedBox(width: AppTheme.spacingXS),
                          Text(
                            result.rating!.toStringAsFixed(1),
                            style: AppTheme.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                        ],
                        if (result.price != null) ...[
                          Text(
                            result.price!,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (onFavoriteTap != null)
                          IconButton(
                            icon: const Icon(Icons.favorite_border, size: 20),
                            onPressed: onFavoriteTap,
                            color: AppTheme.textTertiaryColor,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                      ],
                    ),
                    // Tags
                    if (result.tags.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacingS),
                      Wrap(
                        spacing: AppTheme.spacingXS,
                        runSpacing: AppTheme.spacingXS,
                        children: result.tags.take(3).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: AppTheme.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusS),
                            ),
                            child: Text(
                              tag,
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    final color = result.type == SearchResultType.restaurant
        ? AppTheme.primaryColor
        : AppTheme.secondaryColor;
    
    final text = result.type == SearchResultType.restaurant
        ? 'Restaurant'
        : 'Menu Item';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        text,
        style: AppTheme.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Icon(
      result.type == SearchResultType.restaurant
          ? Icons.restaurant
          : Icons.fastfood,
      size: 32,
      color: AppTheme.textTertiaryColor,
    );
  }
}
