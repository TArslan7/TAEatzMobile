import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';

class HomeSearchSection extends StatelessWidget {
  final ThemeManager themeManager;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const HomeSearchSection({
    super.key,
    required this.themeManager,
    required this.searchController,
    required this.onSearch,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: themeManager.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(
          color: themeManager.textColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search for restaurants or dishes...',
          hintStyle: TextStyle(
            color: themeManager.textColor.withOpacity(0.6),
            fontSize: 16,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeManager.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.search,
              color: themeManager.primaryRed,
              size: 20,
            ),
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: themeManager.textColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    searchController.clear();
                    onSearch('');
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: themeManager.textColor.withOpacity(0.5),
                  ),
                  onPressed: () {},
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
        onSubmitted: onSearch,
        onChanged: (value) {
          if (value.isEmpty) {
            onSearch('');
          }
        },
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.location_on,
            title: 'Nearby',
            color: const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.timer,
            title: 'Fastest',
            color: const Color(0xFFFF9800),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            icon: Icons.star,
            title: 'Top Rated',
            color: const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

