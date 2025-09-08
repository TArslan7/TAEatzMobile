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
          margin: const EdgeInsets.all(AppTheme.spacingM),
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: themeManager.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            boxShadow: [
              BoxShadow(
                color: themeManager.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showAvatarSelector(context, themeManager);
                    },
                    child: AvatarWidget(
                      avatarId: user.avatarId,
                      size: 100,
                      initials: user.initials,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showAvatarSelector(context, themeManager);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeManager.primaryRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeManager.cardColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                user.fullName,
                style: AppTheme.heading5.copyWith(
                  color: themeManager.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                user.email,
                style: AppTheme.bodyMedium.copyWith(
                  color: themeManager.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              if (user.phoneNumber != null) ...[
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  user.phoneNumber!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: themeManager.textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppTheme.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildVerificationBadge(
                    icon: Icons.email,
                    isVerified: user.isEmailVerified,
                    label: 'Email',
                    themeManager: themeManager,
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  _buildVerificationBadge(
                    icon: Icons.phone,
                    isVerified: user.isPhoneVerified,
                    label: 'Phone',
                    themeManager: themeManager,
                  ),
                ],
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

  Widget _buildVerificationBadge({
    required IconData icon,
    required bool isVerified,
    required String label,
    required ThemeManager themeManager,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: isVerified
            ? AppTheme.successColor.withOpacity(0.1)
            : themeManager.textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isVerified ? AppTheme.successColor : themeManager.textColor.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: isVerified ? AppTheme.successColor : themeManager.textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isVerified ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isVerified ? AppTheme.successColor : themeManager.textColor.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
