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
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfile());
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
            actions: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: themeManager.textColor,
                ),
                onPressed: () {
                  _showNotificationsDialog(themeManager);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: themeManager.textColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
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
                    const SizedBox(height: AppTheme.spacingXL),
                    
                    // Quick Actions
                    ProfileSection(
                      title: 'Quick Actions',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.settings,
                          title: 'Settings',
                          subtitle: 'App preferences and configuration',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.history,
                          title: 'Order History',
                          subtitle: 'View your past orders',
                          onTap: () {
                            // Navigate to orders tab
                            DefaultTabController.of(context).animateTo(2);
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Favorites',
                          subtitle: 'Your favorite restaurants',
                          onTap: () {
                            // TODO: Navigate to favorites
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Favorites coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Account Actions
                    ProfileSection(
                      title: 'Account',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          subtitle: 'Sign out of your account',
                          textColor: AppTheme.errorColor,
                          onTap: () {
                            _showSignOutDialog();
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

  void _showNotificationsDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Notifications',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.notifications_active,
                color: themeManager.primaryRed,
              ),
              title: Text(
                'Order Updates',
                style: TextStyle(color: themeManager.textColor),
              ),
              subtitle: Text(
                'Get notified when your order status changes',
                style: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
              ),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Implement order notifications toggle
                },
                activeColor: themeManager.primaryRed,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.local_offer,
                color: themeManager.primaryRed,
              ),
              title: Text(
                'Promotions',
                style: TextStyle(color: themeManager.textColor),
              ),
              subtitle: Text(
                'Receive special offers and discounts',
                style: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
              ),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Implement promotion notifications toggle
                },
                activeColor: themeManager.primaryRed,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.delivery_dining,
                color: themeManager.primaryRed,
              ),
              title: Text(
                'Delivery Updates',
                style: TextStyle(color: themeManager.textColor),
              ),
              subtitle: Text(
                'Track your delivery in real-time',
                style: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
              ),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Implement delivery notifications toggle
                },
                activeColor: themeManager.primaryRed,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            child: Text(
              'Settings',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sign out
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

}
