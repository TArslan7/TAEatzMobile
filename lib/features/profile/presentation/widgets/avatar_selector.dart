import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';

class AvatarSelector extends StatefulWidget {
  final String? currentAvatar;
  final Function(String) onAvatarSelected;

  const AvatarSelector({
    super.key,
    this.currentAvatar,
    required this.onAvatarSelected,
  });

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Dialog(
          backgroundColor: themeManager.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Your Avatar',
                  style: AppTheme.heading6.copyWith(
                    color: themeManager.textColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                // Gradient Avatars
                _buildSectionTitle('Gradient Colors', themeManager),
                const SizedBox(height: AppTheme.spacingM),
                _buildGradientAvatars(themeManager),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Icon Avatars
                _buildSectionTitle('Icons', themeManager),
                const SizedBox(height: AppTheme.spacingM),
                _buildIconAvatars(themeManager),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: themeManager.textColor.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _selectedAvatar != null
                            ? () {
                                widget.onAvatarSelected(_selectedAvatar!);
                                Navigator.of(context).pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeManager.primaryRed,
                        ),
                        child: const Text('Select'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, ThemeManager themeManager) {
    return Text(
      title,
      style: AppTheme.heading6.copyWith(
        color: themeManager.textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGradientAvatars(ThemeManager themeManager) {
    final gradients = [
      {
        'id': 'gradient_red',
        'name': 'Red',
        'gradient': LinearGradient(
          colors: [themeManager.primaryRed, themeManager.primaryRed.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': 'gradient_green',
        'name': 'Green',
        'gradient': LinearGradient(
          colors: [themeManager.secondaryGreen, themeManager.secondaryGreen.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': 'gradient_yellow',
        'name': 'Yellow',
        'gradient': LinearGradient(
          colors: [themeManager.accentYellow, themeManager.accentYellow.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': 'gradient_blue',
        'name': 'Blue',
        'gradient': LinearGradient(
          colors: [Colors.blue, Colors.blue.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': 'gradient_purple',
        'name': 'Purple',
        'gradient': LinearGradient(
          colors: [Colors.purple, Colors.purple.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'id': 'gradient_orange',
        'name': 'Orange',
        'gradient': LinearGradient(
          colors: [Colors.orange, Colors.orange.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppTheme.spacingS,
        mainAxisSpacing: AppTheme.spacingS,
        childAspectRatio: 1,
      ),
      itemCount: gradients.length,
      itemBuilder: (context, index) {
        final gradient = gradients[index];
        final isSelected = _selectedAvatar == gradient['id'];
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAvatar = gradient['id'] as String;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient['gradient'] as LinearGradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? themeManager.primaryRed : Colors.transparent,
                width: 3,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildIconAvatars(ThemeManager themeManager) {
    final icons = [
      {'id': 'icon_person', 'icon': Icons.person, 'name': 'Person'},
      {'id': 'icon_face', 'icon': Icons.face, 'name': 'Face'},
      {'id': 'icon_sentiment', 'icon': Icons.sentiment_very_satisfied, 'name': 'Happy'},
      {'id': 'icon_emoji', 'icon': Icons.emoji_emotions, 'name': 'Emoji'},
      {'id': 'icon_account', 'icon': Icons.account_circle, 'name': 'Account'},
      {'id': 'icon_badge', 'icon': Icons.badge, 'name': 'Badge'},
      {'id': 'icon_star', 'icon': Icons.star, 'name': 'Star'},
      {'id': 'icon_favorite', 'icon': Icons.favorite, 'name': 'Heart'},
      {'id': 'icon_thumb', 'icon': Icons.thumb_up, 'name': 'Thumbs Up'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppTheme.spacingS,
        mainAxisSpacing: AppTheme.spacingS,
        childAspectRatio: 1,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final iconData = icons[index];
        final isSelected = _selectedAvatar == iconData['id'];
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAvatar = iconData['id'] as String;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? themeManager.primaryRed.withOpacity(0.2)
                  : themeManager.cardColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? themeManager.primaryRed : themeManager.textColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              iconData['icon'] as IconData,
              color: isSelected ? themeManager.primaryRed : themeManager.textColor,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final String? avatarId;
  final double size;
  final String? initials;

  const AvatarWidget({
    super.key,
    this.avatarId,
    this.size = 50,
    this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        if (avatarId == null) {
          return _buildDefaultAvatar(themeManager);
        }

        if (avatarId!.startsWith('gradient_')) {
          return _buildGradientAvatar(avatarId!, themeManager);
        } else if (avatarId!.startsWith('icon_')) {
          return _buildIconAvatar(avatarId!, themeManager);
        }

        return _buildDefaultAvatar(themeManager);
      },
    );
  }

  Widget _buildDefaultAvatar(ThemeManager themeManager) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeManager.primaryRed.withOpacity(0.8),
            themeManager.primaryRed.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: initials != null
          ? Center(
              child: Text(
                initials!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Icon(
              Icons.person,
              color: Colors.white,
              size: size * 0.6,
            ),
    );
  }

  Widget _buildGradientAvatar(String avatarId, ThemeManager themeManager) {
    LinearGradient gradient;
    
    switch (avatarId) {
      case 'gradient_red':
        gradient = LinearGradient(
          colors: [themeManager.primaryRed, themeManager.primaryRed.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'gradient_green':
        gradient = LinearGradient(
          colors: [themeManager.secondaryGreen, themeManager.secondaryGreen.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'gradient_yellow':
        gradient = LinearGradient(
          colors: [themeManager.accentYellow, themeManager.accentYellow.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'gradient_blue':
        gradient = LinearGradient(
          colors: [Colors.blue, Colors.blue.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'gradient_purple':
        gradient = LinearGradient(
          colors: [Colors.purple, Colors.purple.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'gradient_orange':
        gradient = LinearGradient(
          colors: [Colors.orange, Colors.orange.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      default:
        return _buildDefaultAvatar(themeManager);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
      ),
      child: initials != null
          ? Center(
              child: Text(
                initials!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Icon(
              Icons.person,
              color: Colors.white,
              size: size * 0.6,
            ),
    );
  }

  Widget _buildIconAvatar(String avatarId, ThemeManager themeManager) {
    IconData iconData;
    
    switch (avatarId) {
      case 'icon_person':
        iconData = Icons.person;
        break;
      case 'icon_face':
        iconData = Icons.face;
        break;
      case 'icon_sentiment':
        iconData = Icons.sentiment_very_satisfied;
        break;
      case 'icon_emoji':
        iconData = Icons.emoji_emotions;
        break;
      case 'icon_account':
        iconData = Icons.account_circle;
        break;
      case 'icon_badge':
        iconData = Icons.badge;
        break;
      case 'icon_star':
        iconData = Icons.star;
        break;
      case 'icon_favorite':
        iconData = Icons.favorite;
        break;
      case 'icon_thumb':
        iconData = Icons.thumb_up;
        break;
      default:
        return _buildDefaultAvatar(themeManager);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: themeManager.primaryRed.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: themeManager.primaryRed.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        iconData,
        color: themeManager.primaryRed,
        size: size * 0.6,
      ),
    );
  }
}
