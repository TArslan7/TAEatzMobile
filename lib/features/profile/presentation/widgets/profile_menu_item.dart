import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? textColor;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.textColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (textColor ?? themeManager.primaryRed).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: textColor ?? themeManager.primaryRed,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: AppTheme.bodyLarge.copyWith(
              color: textColor ?? themeManager.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: AppTheme.bodyMedium.copyWith(
              color: themeManager.textColor.withOpacity(0.7),
            ),
          ),
          trailing: trailing ?? Icon(
            Icons.chevron_right,
            color: themeManager.textColor.withOpacity(0.5),
            size: 18,
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
        );
      },
    );
  }
}
