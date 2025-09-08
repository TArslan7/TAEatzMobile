import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: user.profileImageUrl != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.profileImageUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Text(
                            user.initials,
                            style: AppTheme.heading4.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        user.initials,
                        style: AppTheme.heading4.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement image picker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image picker not implemented yet')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.surfaceColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
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
            style: AppTheme.heading5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            user.email,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (user.phoneNumber != null) ...[
            const SizedBox(height: AppTheme.spacingS),
            Text(
              user.phoneNumber!,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
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
              ),
              const SizedBox(width: AppTheme.spacingM),
              _buildVerificationBadge(
                icon: Icons.phone,
                isVerified: user.isPhoneVerified,
                label: 'Phone',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge({
    required IconData icon,
    required bool isVerified,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: isVerified
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.textSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isVerified ? AppTheme.successColor : AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: isVerified ? AppTheme.successColor : AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isVerified ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isVerified ? AppTheme.successColor : AppTheme.textSecondaryColor,
          ),
        ],
      ),
    );
  }
}
