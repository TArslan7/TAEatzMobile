import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Settings',
              style: TextStyle(color: themeManager.textColor),
            ),
            backgroundColor: themeManager.cardColor,
            elevation: 0,
            iconTheme: IconThemeData(color: themeManager.textColor),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: themeManager.textColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppTheme.spacingM),
                
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
                        value: true,
                        onChanged: (value) {
                          // TODO: Implement email notification toggle
                        },
                        activeColor: themeManager.primaryRed,
                      ),
                      onTap: () {
                        // TODO: Implement email notification toggle
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Privacy Settings
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
                        // TODO: Navigate to security page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Security settings coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Account Settings
                ProfileSection(
                  title: 'Account',
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
                        // TODO: Navigate to edit profile page
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
                        // TODO: Navigate to address page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Address management coming soon!')),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.favorite_outline,
                      title: 'Preferences',
                      subtitle: 'Dietary preferences and allergies',
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: themeManager.textColor.withOpacity(0.5),
                      ),
                      onTap: () {
                        // TODO: Navigate to preferences page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Preferences coming soon!')),
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
                
                const SizedBox(height: AppTheme.spacingXL),
              ],
            ),
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
}
