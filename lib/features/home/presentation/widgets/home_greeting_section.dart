import 'package:flutter/material.dart';
import '../../../../core/theme/theme_manager.dart';

class HomeGreetingSection extends StatelessWidget {
  final ThemeManager themeManager;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> eatDrinkAnimation;
  final String Function() getTimeBasedGreeting;

  const HomeGreetingSection({
    super.key,
    required this.themeManager,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.eatDrinkAnimation,
    required this.getTimeBasedGreeting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            themeManager.primaryRed.withOpacity(0.98),
            themeManager.primaryRed.withOpacity(0.96),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left - Greeting Text
          Expanded(
            child: _buildGreetingText(),
          ),
          
          const SizedBox(width: 12),
          
          // Right - Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildGreetingText() {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Time-based greeting
            Text(
              getTimeBasedGreeting(),
              style: TextStyle(
                color: themeManager.textColor.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            
            // Animated main message
            AnimatedBuilder(
              animation: eatDrinkAnimation,
              builder: (context, child) {
                final isEat = eatDrinkAnimation.value < 0.5;
                final text = isEat ? 'eat' : 'drink';
                final emoji = isEat ? '🍽️' : '🥤';
                
                final fadeValue = isEat 
                    ? (1.0 - (eatDrinkAnimation.value * 2)).clamp(0.0, 1.0)
                    : ((eatDrinkAnimation.value - 0.5) * 2).clamp(0.0, 1.0);
                
                return AnimatedOpacity(
                  opacity: fadeValue,
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedSlide(
                    offset: Offset(0, isEat ? 0.0 : 0.05),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Text(
                      'What would you like to $text? $emoji',
                      style: TextStyle(
                        color: themeManager.textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(
            icon: Icons.notifications_outlined,
            onTap: () {},
            badge: true,
          ),
          const SizedBox(width: 4),
          _buildActionButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () {},
            badge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool badge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: themeManager.textColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: themeManager.textColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                color: themeManager.textColor,
                size: 16,
              ),
            ),
            if (badge)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5722),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

