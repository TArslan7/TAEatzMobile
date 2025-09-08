import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvancedUIComponents {
  // Glassmorphism Card
  static Widget glassmorphismCard({
    required Widget child,
    double opacity = 0.1,
    double blur = 10.0,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withOpacity(opacity),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: blur,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }

  // Neumorphism Button
  static Widget neumorphismButton({
    required VoidCallback onPressed,
    required Widget child,
    double width = 200,
    double height = 50,
    Color color = Colors.grey,
    bool isPressed = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    blurRadius: 15,
                    offset: const Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                ],
        ),
        child: Center(child: child),
      ),
    );
  }

  // Animated Counter
  static Widget animatedCounter({
    required int value,
    required TextStyle style,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      builder: (context, animatedValue, child) {
        return Text(
          animatedValue.toString(),
          style: style,
        );
      },
    );
  }

  // Shimmer Loading Effect
  static Widget shimmerLoading({
    required Widget child,
    bool isLoading = true,
    Color baseColor = Colors.grey,
    Color highlightColor = Colors.white,
  }) {
    if (!isLoading) return child;
    
    return ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }

  // Floating Action Button with Menu
  static Widget floatingActionMenu({
    required List<FloatingActionItem> items,
    required VoidCallback onPressed,
    IconData icon = Icons.add,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: Icon(icon),
    );
  }

  // Parallax Scrolling Widget
  static Widget parallaxScroll({
    required Widget child,
    required ScrollController scrollController,
    double parallaxFactor = 0.5,
  }) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        final offset = scrollController.hasClients ? scrollController.offset : 0.0;
        return Transform.translate(
          offset: Offset(0, offset * parallaxFactor),
          child: child,
        );
      },
      child: child,
    );
  }

  // Interactive Rating Widget
  static Widget interactiveRating({
    required double rating,
    required ValueChanged<double> onRatingChanged,
    int itemCount = 5,
    double itemSize = 40.0,
    Color? color,
    Color? unratedColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, (index) {
        final itemRating = index + 1;
        final isRated = itemRating <= rating;
        final isHalfRated = itemRating - 0.5 <= rating && rating < itemRating;
        
        return GestureDetector(
          onTap: () => onRatingChanged(itemRating.toDouble()),
          child: Icon(
            isRated
                ? Icons.star
                : isHalfRated
                    ? Icons.star_half
                    : Icons.star_border,
            size: itemSize,
            color: isRated || isHalfRated
                ? (color ?? Colors.amber)
                : (unratedColor ?? Colors.grey),
          ),
        );
      }),
    );
  }

  // Animated Progress Bar
  static Widget animatedProgressBar({
    required double progress,
    double height = 8.0,
    Color? backgroundColor,
    Color? progressColor,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress),
      duration: duration,
      builder: (context, animatedProgress, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedProgress,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor ?? Colors.blue,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        );
      },
    );
  }

  // Custom Slider
  static Widget customSlider({
    required double value,
    required ValueChanged<double> onChanged,
    double min = 0.0,
    double max = 100.0,
    Color? activeColor,
    Color? inactiveColor,
    double height = 20.0,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: activeColor ?? Colors.blue,
        inactiveTrackColor: inactiveColor ?? Colors.grey[300],
        thumbColor: activeColor ?? Colors.blue,
        trackHeight: height,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: height / 2),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
      ),
    );
  }

  // Expandable Card
  static Widget expandableCard({
    required String title,
    required Widget content,
    bool isExpanded = false,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: isExpanded,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ],
    );
  }

  // Animated List Item
  static Widget animatedListItem({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * delay.inMilliseconds)),
      builder: (context, animatedValue, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animatedValue)),
          child: Opacity(
            opacity: animatedValue,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Custom Bottom Sheet
  static void showCustomBottomSheet({
    required BuildContext context,
    required Widget child,
    double height = 0.5,
    bool isDismissible = true,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: child,
      ),
    );
  }

  // Haptic Feedback Button
  static Widget hapticButton({
    required VoidCallback onPressed,
    required Widget child,
    HapticFeedbackType feedbackType = HapticFeedbackType.lightImpact,
  }) {
    return GestureDetector(
      onTap: () {
        switch (feedbackType) {
          case HapticFeedbackType.lightImpact:
            HapticFeedback.lightImpact();
            break;
          case HapticFeedbackType.mediumImpact:
            HapticFeedback.mediumImpact();
            break;
          case HapticFeedbackType.heavyImpact:
            HapticFeedback.heavyImpact();
            break;
          case HapticFeedbackType.selectionClick:
            HapticFeedback.selectionClick();
            break;
        }
        onPressed();
      },
      child: child,
    );
  }
}

// Shimmer Effect Widget
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Floating Action Item
class FloatingActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const FloatingActionItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });
}

// Haptic Feedback Types
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
}
