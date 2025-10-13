import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_manager.dart';

class HomeStatsSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const HomeStatsSection({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.delivery_dining,
                      title: 'Fast Delivery',
                      subtitle: '15-30 min',
                      color: const Color(0xFF4CAF50),
                      themeManager: themeManager,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.star,
                      title: '4.8 Rating',
                      subtitle: 'Based on 2.5k+ reviews',
                      color: const Color(0xFFFF9800),
                      themeManager: themeManager,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.restaurant,
                      title: '200+ Restaurants',
                      subtitle: 'Near you',
                      color: const Color(0xFF2196F3),
                      themeManager: themeManager,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required ThemeManager themeManager,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeManager.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: themeManager.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: themeManager.textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

