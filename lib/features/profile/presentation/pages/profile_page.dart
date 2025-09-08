import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section.dart';
import 'edit_profile_page.dart';
import 'preferences_page.dart';
import 'address_page.dart';
import 'security_page.dart';

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
                  Icons.brightness_6_outlined,
                  color: themeManager.textColor,
                ),
                onPressed: () => themeManager.toggleTheme(),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: themeManager.textColor,
                ),
                onPressed: () {
                  // TODO: Navigate to settings
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ProfileHeader(user: state.user),
                    const SizedBox(height: AppTheme.spacingL),
                    ProfileSection(
                      title: 'Account',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(user: state.user),
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Address',
                          subtitle: 'Manage your delivery addresses',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddressPage(user: state.user),
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Preferences',
                          subtitle: 'Dietary preferences and allergies',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PreferencesPage(user: state.user),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    ProfileSection(
                      title: 'Security',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.lock_outline,
                          title: 'Password & Security',
                          subtitle: 'Change password and security settings',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SecurityPage(user: state.user),
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.phone_outlined,
                          title: 'Phone Number',
                          subtitle: state.user.phoneNumber ?? 'Add phone number',
                          onTap: () {
                            // TODO: Navigate to phone verification
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    ProfileSection(
                      title: 'Support',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help and contact support',
                          onTap: () {
                            // TODO: Navigate to help page
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          subtitle: 'App version and information',
                          onTap: () {
                            // TODO: Navigate to about page
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingL),
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
                        ProfileMenuItem(
                          icon: Icons.delete_outline,
                          title: 'Delete Account',
                          subtitle: 'Permanently delete your account',
                          textColor: AppTheme.errorColor,
                          onTap: () {
                            _showDeleteAccountDialog();
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ProfileBloc>().add(const DeleteAccount());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
