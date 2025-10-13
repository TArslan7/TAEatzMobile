import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../domain/entities/achievement_entity.dart';
import '../widgets/achievements_section.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage>
    with SingleTickerProviderStateMixin {
  late List<AchievementEntity> _achievements;
  late AnimationController _rewardCollectionController;

  @override
  void initState() {
    super.initState();
    _initializeAchievements();
    _rewardCollectionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rewardCollectionController.dispose();
    super.dispose();
  }

  void _initializeAchievements() {
    _achievements = [
      // Unlocked achievement
      const AchievementEntity(
        id: '1',
        title: 'First Steps',
        description: 'Complete your first order',
        type: AchievementType.orders,
        status: AchievementStatus.unlocked,
        currentProgress: 1,
        targetProgress: 1,
        rewardTitle: 'Free Delivery',
        rewardDescription: 'Get free delivery on your next order',
        icon: '🎉',
        points: 50,
      ),
      // In progress - next achievement
      const AchievementEntity(
        id: '2',
        title: 'Food Explorer',
        description: 'Order from 5 different restaurants',
        type: AchievementType.orders,
        status: AchievementStatus.inProgress,
        currentProgress: 3,
        targetProgress: 5,
        rewardTitle: 'Free Meal 🍔',
        rewardDescription: 'Get a free meal worth up to \$15',
        icon: '🍕',
        points: 100,
      ),
      // In progress
      const AchievementEntity(
        id: '3',
        title: 'Review Master',
        description: 'Write 10 helpful reviews',
        type: AchievementType.reviews,
        status: AchievementStatus.inProgress,
        currentProgress: 7,
        targetProgress: 10,
        rewardTitle: '\$5 Credit',
        rewardDescription: 'Receive \$5 credit on your account',
        icon: '⭐',
        points: 75,
      ),
      // Locked
      const AchievementEntity(
        id: '4',
        title: 'Big Spender',
        description: 'Spend \$100 in total',
        type: AchievementType.spending,
        status: AchievementStatus.locked,
        currentProgress: 0,
        targetProgress: 100,
        rewardTitle: '20% Off Coupon',
        rewardDescription: 'Get 20% off your next order',
        icon: '💰',
        points: 150,
      ),
      // In progress
      const AchievementEntity(
        id: '5',
        title: 'Loyalty Badge',
        description: 'Order for 7 consecutive days',
        type: AchievementType.streaks,
        status: AchievementStatus.inProgress,
        currentProgress: 4,
        targetProgress: 7,
        rewardTitle: 'VIP Status',
        rewardDescription: 'Unlock VIP benefits for 30 days',
        icon: '🔥',
        points: 200,
      ),
      // Locked
      const AchievementEntity(
        id: '6',
        title: 'Social Butterfly',
        description: 'Refer 5 friends',
        type: AchievementType.referrals,
        status: AchievementStatus.locked,
        currentProgress: 0,
        targetProgress: 5,
        rewardTitle: '\$25 Credit',
        rewardDescription: 'Get \$25 credit when all friends complete their first order',
        icon: '🦋',
        points: 250,
      ),
      // In progress
      const AchievementEntity(
        id: '7',
        title: 'Night Owl',
        description: 'Order 5 times after midnight',
        type: AchievementType.orders,
        status: AchievementStatus.inProgress,
        currentProgress: 2,
        targetProgress: 5,
        rewardTitle: 'Late Night Special',
        rewardDescription: 'Get 15% off all orders after 11 PM',
        icon: '🦉',
        points: 100,
      ),
      // More achievements
      const AchievementEntity(
        id: '8',
        title: 'Early Bird',
        description: 'Order breakfast 5 times before 9 AM',
        type: AchievementType.orders,
        status: AchievementStatus.inProgress,
        currentProgress: 1,
        targetProgress: 5,
        rewardTitle: 'Free Coffee',
        rewardDescription: 'Get a free coffee with any breakfast order',
        icon: '🌅',
        points: 80,
      ),
      const AchievementEntity(
        id: '9',
        title: 'Healthy Eater',
        description: 'Order 10 healthy meals',
        type: AchievementType.orders,
        status: AchievementStatus.locked,
        currentProgress: 0,
        targetProgress: 10,
        rewardTitle: 'Health Discount',
        rewardDescription: 'Get 25% off all healthy options',
        icon: '🥗',
        points: 120,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        // Calculate stats
        final totalPoints = _achievements
            .where((a) => a.isCollected)
            .fold<int>(0, (sum, a) => sum + a.points);
        final unlockedCount = _achievements.where((a) => a.isUnlocked || a.isCollected).length;

        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Achievements',
              style: TextStyle(color: themeManager.textColor),
            ),
            backgroundColor: themeManager.cardColor,
            elevation: 0,
            iconTheme: IconThemeData(color: themeManager.textColor),
            actions: [
              // Stats badge
              Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingM),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          themeManager.primaryRed,
                          themeManager.primaryRed.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$totalPoints pts',
                          style: AppTheme.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Refresh achievements
              await Future.delayed(const Duration(milliseconds: 500));
            },
            color: themeManager.primaryRed,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header Stats
                  Container(
                    margin: const EdgeInsets.all(AppTheme.spacingM),
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeManager.primaryRed.withOpacity(0.15),
                          Colors.black.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      border: Border.all(
                        color: themeManager.primaryRed.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            themeManager,
                            'Total Points',
                            totalPoints.toString(),
                            Icons.stars,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: themeManager.textColor.withOpacity(0.2),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            themeManager,
                            'Unlocked',
                            '$unlockedCount/${_achievements.length}',
                            Icons.emoji_events,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingS),

                  // Achievements Section
                  AchievementsSection(
                    achievements: _achievements,
                    onCollectReward: _handleCollectReward,
                  ),

                  const SizedBox(height: AppTheme.spacingXL),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    ThemeManager themeManager,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: themeManager.primaryRed,
          size: 24,
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          value,
          style: AppTheme.heading5.copyWith(
            color: themeManager.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: themeManager.textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  void _handleCollectReward(AchievementEntity achievement) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);

    _rewardCollectionController.forward(from: 0.0).then((_) {
      // Update achievement status
      setState(() {
        final index = _achievements.indexWhere((a) => a.id == achievement.id);
        if (index != -1) {
          _achievements[index] = achievement.copyWith(
            status: AchievementStatus.collected,
            collectedAt: DateTime.now(),
          );
        }
      });

      // Show reward collected dialog
      _showRewardCollectedDialog(achievement, themeManager);
    });
  }

  void _showRewardCollectedDialog(
    AchievementEntity achievement,
    ThemeManager themeManager,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _RewardCollectedDialog(
        achievement: achievement,
        themeManager: themeManager,
      ),
    );
  }
}

class _RewardCollectedDialog extends StatefulWidget {
  final AchievementEntity achievement;
  final ThemeManager themeManager;

  const _RewardCollectedDialog({
    required this.achievement,
    required this.themeManager,
  });

  @override
  State<_RewardCollectedDialog> createState() => _RewardCollectedDialogState();
}

class _RewardCollectedDialogState extends State<_RewardCollectedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 0.1,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.themeManager.primaryRed,
                      widget.themeManager.primaryRed.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: widget.themeManager.primaryRed.withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Celebration icon
                    const Text(
                      '🎉',
                      style: TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: AppTheme.spacingM),

                    // Title
                    Text(
                      'Reward Collected!',
                      style: AppTheme.heading5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    // Achievement icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.achievement.icon,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingM),

                    // Reward title
                    Text(
                      widget.achievement.rewardTitle,
                      style: AppTheme.heading6.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    // Reward description
                    Text(
                      widget.achievement.rewardDescription,
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    // Points
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '+${widget.achievement.points} Points',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingL),

                    // Close button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: widget.themeManager.primaryRed,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                        ),
                        child: const Text(
                          'Awesome!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

