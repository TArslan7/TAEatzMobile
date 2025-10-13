import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  String _selectedLanguage = 'English';

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
              style: AppTheme.heading6.copyWith(
                color: themeManager.textColor,
                fontWeight: FontWeight.bold,
              ),
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
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(const RefreshProfile());
              },
              color: themeManager.primaryRed,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Profile Header with Welcome Message
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacingXL,
                        horizontal: AppTheme.spacingL,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            themeManager.primaryRed.withOpacity(0.15),
                            Colors.black.withOpacity(0.05),
                            themeManager.primaryRed.withOpacity(0.08),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Profile Picture
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeManager.primaryRed.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: themeManager.primaryRed.withOpacity(0.3),
                                  child: Text(
                                    state.user.initials,
                                    style: AppTheme.heading4.copyWith(
                                      color: themeManager.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: AppTheme.spacingM),
                          
                          // Welcome Message
                          Text(
                            'Welcome, ${state.user.firstName}!',
                            style: AppTheme.heading5.copyWith(
                              color: themeManager.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Account Section
                    ProfileSection(
                      title: 'Account',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Personal Details',
                          subtitle: state.user.email,
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Personal details coming soon!')),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Delivery Addresses',
                          subtitle: 'Manage your saved addresses',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Delivery addresses coming soon!')),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Settings Section
                    ProfileSection(
                      title: 'Settings',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.flag_outlined,
                          title: 'Country',
                          subtitle: 'Netherlands',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Country selection coming soon!')),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Location Services',
                          subtitle: 'Enable location for better experience',
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
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Manage notification preferences',
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
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Need Help
                    ProfileSection(
                      title: 'Support',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Need Help',
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
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Feedback
                    ProfileSection(
                      title: 'Feedback',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.feedback_outlined,
                          title: 'Give us Feedback',
                          subtitle: 'Share your thoughts with us',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            _showFeedbackDialog(themeManager);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Links
                    ProfileSection(
                      title: 'Links',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Legal, Data and Privacy',
                          subtitle: 'Terms, policies and your data',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            _showLegalDialog(themeManager);
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.handshake_outlined,
                          title: 'Partner with Us',
                          subtitle: 'Join our restaurant network',
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeManager.textColor.withOpacity(0.5),
                          ),
                          onTap: () {
                            _showPartnerDialog(themeManager);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Log Out
                    ProfileSection(
                      title: 'Account Actions',
                      children: [
                        ProfileMenuItem(
                          icon: Icons.logout,
                          title: 'Log Out',
                          subtitle: 'Sign out of your account',
                          textColor: themeManager.primaryRed,
                          onTap: () {
                            _showSignOutDialog(themeManager);
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.delete_outline,
                          title: 'Delete Your Account',
                          subtitle: 'Permanently delete your account',
                          textColor: AppTheme.errorColor,
                          onTap: () {
                            _showDeleteAccountDialog(themeManager);
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

  void _showFeedbackDialog(ThemeManager themeManager) {
    final feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Give us Feedback',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We value your feedback! Let us know how we can improve.',
              style: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              style: TextStyle(color: themeManager.textColor),
              decoration: InputDecoration(
                hintText: 'Type your feedback here...',
                hintStyle: TextStyle(color: themeManager.textColor.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: themeManager.textColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: themeManager.primaryRed),
                ),
              ),
            ),
          ],
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
              // TODO: Submit feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Thank you for your feedback!'),
                  backgroundColor: themeManager.primaryRed,
                ),
              );
            },
            child: Text(
              'Submit',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showLegalDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Legal, Data and Privacy',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.description, color: themeManager.primaryRed),
                title: Text('Terms of Service', style: TextStyle(color: themeManager.textColor)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip, color: themeManager.primaryRed),
                title: Text('Privacy Policy', style: TextStyle(color: themeManager.textColor)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.cookie, color: themeManager.primaryRed),
                title: Text('Cookie Policy', style: TextStyle(color: themeManager.textColor)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.security, color: themeManager.primaryRed),
                title: Text('Data Protection', style: TextStyle(color: themeManager.textColor)),
                onTap: () {},
              ),
            ],
          ),
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

  void _showPartnerDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Partner with Us',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Text(
          'Are you a restaurant owner?\n\nJoin TAEatz and reach thousands of hungry customers!\n\nEmail: partners@taeatz.com\nPhone: +31 20 123 4567\n\nWe look forward to working with you!',
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
          'Log Out',
          style: TextStyle(color: themeManager.textColor),
        ),
        content: Text(
          'Are you sure you want to log out?',
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
                  content: const Text('Logged out successfully'),
                  backgroundColor: themeManager.primaryRed,
                ),
              );
            },
            child: Text(
              'Log Out',
              style: TextStyle(color: themeManager.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.cardColor,
        title: Text(
          'Delete Your Account',
          style: TextStyle(color: AppTheme.errorColor),
        ),
        content: Text(
          'This action cannot be undone!\n\nDeleting your account will:\n• Remove all your personal data\n• Cancel active orders\n• Delete saved addresses\n• Remove payment methods\n\nAre you absolutely sure?',
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
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion requires verification'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

}
