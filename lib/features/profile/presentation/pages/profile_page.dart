import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section.dart';
import '../widgets/achievement_progress_bar.dart';
import '../widgets/achievements_section.dart';
import '../../domain/entities/achievement_entity.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _locationEnabled = true;
  String _selectedLanguage = 'English';
  late List<AchievementEntity> _achievements;
  late AnimationController _rewardCollectionController;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfile());
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Profile',
              style: TextStyle(color: themeManager.textColor),
            ),
            backgroundColor: themeManager.cardColor,
            elevation: 0,
            iconTheme: IconThemeData(color: themeManager.textColor),
          ),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: themeManager.primaryRed,
                  ),
                );
              }

              if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: themeManager.primaryRed,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Text(
                        'Error loading profile',
                        style: AppTheme.heading6.copyWith(
                          color: themeManager.textColor,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        state.message,
                        style: AppTheme.bodyMedium.copyWith(
                          color: themeManager.textColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(const LoadProfile());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeManager.primaryRed,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

          if (state is ProfileLoaded) {
            // Find next achievement to show in progress bar
            final nextAchievement = _achievements
                .where((a) => a.isInProgress)
                .reduce((a, b) => a.progressPercentage > b.progressPercentage ? a : b);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(const RefreshProfile());
              },
              color: themeManager.primaryRed,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ProfileHeader(user: state.user),
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Achievement Progress Bar
                    AchievementProgressBar(
                      nextAchievement: nextAchievement,
                      onTap: () {
                        // Scroll to achievements section
                        // This could be implemented with a ScrollController if needed
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Achievements Section
                    AchievementsSection(
                      achievements: _achievements,
                      onCollectReward: _handleCollectReward,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXL),
                    
                    // Account Management
                    ProfileSection(
                      title: 'Account Management',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Edit profile coming soon!')),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Delivery Addresses',
                          subtitle: 'Manage your delivery addresses',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Address management coming soon!')),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Dietary Preferences',
                          subtitle: 'Preferences and allergies',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Preferences coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Appearance Settings
                    ProfileSection(
                      title: 'Appearance',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.brightness_6_outlined,
                          title: 'Dark Mode',
                          subtitle: 'Switch between light and dark theme',
                          trailing: Switch(
                            value: themeManager.themeMode == ThemeMode.dark,
                            onChanged: (value) {
                              themeManager.toggleTheme();
                            },
                            activeColor: themeManager.primaryRed,
                          ),
                          onTap: () {
                            themeManager.toggleTheme();
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.language_outlined,
                          title: 'Language',
                          subtitle: _selectedLanguage,
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            _showLanguageDialog(themeManager);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Notifications Settings
                    ProfileSection(
                      title: 'Notifications',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Push Notifications',
                          subtitle: 'Receive order updates and promotions',
                          trailing: Switch(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                              _showNotificationSettings(themeManager);
                            },
                            activeColor: themeManager.primaryRed,
                          ),
                          onTap: () {
                            setState(() {
                              _notificationsEnabled = !_notificationsEnabled;
                            });
                            _showNotificationSettings(themeManager);
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.email_outlined,
                          title: 'Email Notifications',
                          subtitle: 'Order confirmations and updates',
                          trailing: Switch(
                            value: _emailNotificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _emailNotificationsEnabled = value;
                              });
                            },
                            activeColor: themeManager.primaryRed,
                          ),
                          onTap: () {
                            setState(() {
                              _emailNotificationsEnabled = !_emailNotificationsEnabled;
                            });
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Privacy & Security
                    ProfileSection(
                      title: 'Privacy & Security',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Location Services',
                          subtitle: 'Allow location access for delivery',
                          trailing: Switch(
                            value: _locationEnabled,
                            onChanged: (value) {
                              setState(() {
                                _locationEnabled = value;
                              });
                            },
                            activeColor: themeManager.primaryRed,
                          ),
                          onTap: () {
                            setState(() {
                              _locationEnabled = !_locationEnabled;
                            });
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.lock_outline,
                          title: 'Privacy Settings',
                          subtitle: 'Manage your privacy preferences',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Security settings coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Quick Actions
                    ProfileSection(
                      title: 'Quick Actions',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.history,
                          title: 'Order History',
                          subtitle: 'View your past orders',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            DefaultTabController.of(context).animateTo(2);
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.favorite,
                          title: 'Favorites',
                          subtitle: 'Your favorite restaurants',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Favorites coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Support
                    ProfileSection(
                      title: 'Support',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help and contact support',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            _showHelpDialog(themeManager);
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          subtitle: 'App version and information',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            _showAboutDialog(themeManager);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Sign Out
                    ProfileSection(
                      title: 'Account Actions',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          subtitle: 'Sign out of your account',
                          textColor: AppTheme.errorColor,
                          onTap: () {
                            _showSignOutDialog(themeManager);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXL),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
      },
    );
  }

  void _showLanguageDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Select Language',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English', themeManager),
            _buildLanguageOption('Nederlands', themeManager),
            _buildLanguageOption('Español', themeManager),
            _buildLanguageOption('Français', themeManager),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, ThemeManager themeManager) {
    return ListTile(
      title: Text(
        language,
        style: TextStyle(color: themeManager.textColor),
      ),
      trailing: _selectedLanguage == language
          ? Icon(Icons.check, color: themeManager.primaryRed)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.of(context).pop();
      },
    );
  }

  void _showNotificationSettings(ThemeManager themeManager) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _notificationsEnabled 
              ? 'Notifications enabled' 
              : 'Notifications disabled',
        ),
        backgroundColor: themeManager.primaryRed,
      ),
    );
  }

  void _showHelpDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Help & Support',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Text(
          'For support, please contact us at:\n\nEmail: support@taeatz.com\nPhone: +31 20 123 4567\n\nWe\'re here to help!',
          style: TextStyle(color: themeManager.textColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'About TAEatz',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Text(
          'TAEatz Mobile App\nVersion 1.0.0\n\n© 2024 TAEatz. All rights reserved.\n\nDelivering delicious food to your doorstep!',
          style: TextStyle(color: themeManager.textColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Sign Out',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: themeManager.textColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sign out
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Signed out successfully'),
                  backgroundColor: themeManager.primaryRed,
                ),
              );
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
        ],
      ),
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
