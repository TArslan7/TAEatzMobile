import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          decoration: BoxDecoration(
            color: themeManager.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: themeManager.primaryRed.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: themeManager.shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    color: themeManager.textColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...children,
            ],
          ),
        );
      },
    );
  }
}
