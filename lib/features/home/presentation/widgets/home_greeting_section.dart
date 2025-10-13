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
          // Greeting Text - Full Width
          Expanded(
            child: _buildGreetingText(),
          ),
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

}

