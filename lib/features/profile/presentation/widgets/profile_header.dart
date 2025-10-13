import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../domain/entities/user_entity.dart';
import 'avatar_selector.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingXL * 2,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle glow effect behind avatar
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
                  // Avatar
                  GestureDetector(
                    onTap: () {
                      _showAvatarSelector(context, themeManager);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: AvatarWidget(
                        avatarId: user.avatarId,
                        size: 90,
                        initials: user.initials,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // User Email
              Text(
                user.email,
                style: AppTheme.bodyLarge.copyWith(
                  color: themeManager.textColor.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAvatarSelector(BuildContext context, ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AvatarSelector(
        currentAvatar: user.avatarId,
        onAvatarSelected: (avatarId) {
          // TODO: Update user avatar in backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Avatar updated to: $avatarId'),
              backgroundColor: themeManager.primaryRed,
            ),
          );
        },
      ),
    );
  }
}
