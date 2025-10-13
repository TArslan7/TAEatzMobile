import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../domain/entities/achievement_entity.dart';

class AchievementProgressBar extends StatefulWidget {
  final AchievementEntity nextAchievement;
  final VoidCallback? onTap;

  const AchievementProgressBar({
    super.key,
    required this.nextAchievement,
    this.onTap,
  });

  @override
  State<AchievementProgressBar> createState() => _AchievementProgressBarState();
}

class _AchievementProgressBarState extends State<AchievementProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.nextAchievement.progressPercentage,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(AchievementProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nextAchievement.currentProgress !=
        widget.nextAchievement.currentProgress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.nextAchievement.progressPercentage,
        end: widget.nextAchievement.progressPercentage,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      );
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeManager.cardColor,
                  themeManager.cardColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: themeManager.primaryRed.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeManager.primaryRed.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and remaining progress
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: themeManager.primaryRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        widget.nextAchievement.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Reward',
                            style: AppTheme.caption.copyWith(
                              color: themeManager.textColor.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.nextAchievement.remainingProgress} more ${_getProgressUnit()} until ${widget.nextAchievement.rewardTitle}',
                            style: AppTheme.bodyMedium.copyWith(
                              color: themeManager.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: themeManager.textColor.withOpacity(0.4),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // Animated Progress Bar
                Stack(
                  children: [
                    // Background
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: themeManager.textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                    ),
                    // Animated Progress
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width *
                              _progressAnimation.value *
                              0.85,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                themeManager.primaryRed,
                                themeManager.primaryRed.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                            boxShadow: [
                              BoxShadow(
                                color: themeManager.primaryRed.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingS),
                
                // Progress percentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.nextAchievement.currentProgress} / ${widget.nextAchievement.targetProgress}',
                      style: AppTheme.caption.copyWith(
                        color: themeManager.textColor.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '${(widget.nextAchievement.progressPercentage * 100).toInt()}%',
                      style: AppTheme.caption.copyWith(
                        color: themeManager.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getProgressUnit() {
    switch (widget.nextAchievement.type) {
      case AchievementType.orders:
        return widget.nextAchievement.remainingProgress == 1 ? 'order' : 'orders';
      case AchievementType.spending:
        return 'spent';
      case AchievementType.reviews:
        return widget.nextAchievement.remainingProgress == 1 ? 'review' : 'reviews';
      case AchievementType.streaks:
        return widget.nextAchievement.remainingProgress == 1 ? 'day' : 'days';
      case AchievementType.referrals:
        return widget.nextAchievement.remainingProgress == 1 ? 'referral' : 'referrals';
      case AchievementType.badges:
        return widget.nextAchievement.remainingProgress == 1 ? 'badge' : 'badges';
    }
  }
}

