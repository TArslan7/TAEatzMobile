import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../domain/entities/achievement_entity.dart';
import 'achievement_card.dart';

class AchievementsSection extends StatelessWidget {
  final List<AchievementEntity> achievements;
  final Function(AchievementEntity) onCollectReward;

  const AchievementsSection({
    super.key,
    required this.achievements,
    required this.onCollectReward,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        // Group achievements by status
        final unlocked = achievements
            .where((a) => a.isUnlocked)
            .toList()
          ..sort((a, b) => b.points.compareTo(a.points));
        
        final inProgress = achievements
            .where((a) => a.isInProgress)
            .toList()
          ..sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));
        
        final locked = achievements
            .where((a) => a.isLocked)
            .toList()
          ..sort((a, b) => a.targetProgress.compareTo(b.targetProgress));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: themeManager.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: themeManager.primaryRed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Achievements & Rewards',
                    style: AppTheme.heading6.copyWith(
                      color: themeManager.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _buildStatsBadge(
                    themeManager,
                    '${unlocked.length}/${achievements.length}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingS),

            // Unlocked Achievements
            if (unlocked.isNotEmpty) ...[
              _buildSectionHeader(
                themeManager,
                'Ready to Collect',
                Icons.celebration,
              ),
              ...unlocked.map((achievement) => AchievementCard(
                    achievement: achievement,
                    onCollectReward: () => onCollectReward(achievement),
                  )),
              const SizedBox(height: AppTheme.spacingM),
            ],

            // In Progress Achievements
            if (inProgress.isNotEmpty) ...[
              _buildSectionHeader(
                themeManager,
                'In Progress',
                Icons.trending_up,
              ),
              ...inProgress.map((achievement) => AchievementCard(
                    achievement: achievement,
                  )),
              const SizedBox(height: AppTheme.spacingM),
            ],

            // Locked Achievements
            if (locked.isNotEmpty) ...[
              _buildSectionHeader(
                themeManager,
                'Upcoming',
                Icons.lock_outline,
              ),
              ...locked.map((achievement) => AchievementCard(
                    achievement: achievement,
                  )),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(
    ThemeManager themeManager,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: themeManager.textColor.withOpacity(0.7),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: themeManager.textColor.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBadge(ThemeManager themeManager, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: themeManager.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Text(
        text,
        style: AppTheme.caption.copyWith(
          color: themeManager.primaryRed,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

