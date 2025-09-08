import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvancedAnimations {
  // Hero animation with custom transitions
  static Widget heroAnimation({
    required String tag,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return Hero(
      tag: tag,
      child: child,
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: Tween<double>(begin: 0.8, end: 1.0).evaluate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }

  // Staggered animation for lists
  static Widget staggeredList({
    required List<Widget> children,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return AnimatedSlideIn(
          duration: animationDuration,
          delay: Duration(milliseconds: index * staggerDelay.inMilliseconds),
          curve: curve,
          child: child,
        );
      }).toList(),
    );
  }

  // Parallax scrolling effect
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

  // Morphing button animation
  static Widget morphingButton({
    required Widget child,
    required VoidCallback onTap,
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.easeInOut,
  }) {
    return _MorphingButton(
      onTap: onTap,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  // Floating action button with custom animation
  static Widget floatingActionButton({
    required VoidCallback onPressed,
    required Widget child,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
    double elevation = 6.0,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    return _AnimatedFloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      animationDuration: animationDuration,
      child: child,
    );
  }

  // Shake animation for errors
  static Widget shakeAnimation({
    required Widget child,
    required bool shouldShake,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return _ShakeAnimation(
      shouldShake: shouldShake,
      duration: duration,
      child: child,
    );
  }

  // Pulse animation for loading states
  static Widget pulseAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minScale = 0.8,
    double maxScale = 1.0,
  }) {
    return _PulseAnimation(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      child: child,
    );
  }

  // Bounce animation for success states
  static Widget bounceAnimation({
    required Widget child,
    required bool shouldBounce,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return _BounceAnimation(
      shouldBounce: shouldBounce,
      duration: duration,
      child: child,
    );
  }

  // Ripple effect for taps
  static Widget rippleEffect({
    required Widget child,
    required VoidCallback onTap,
    Color? rippleColor,
    double borderRadius = 0.0,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: rippleColor ?? Colors.grey.withOpacity(0.3),
        highlightColor: rippleColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
        child: child,
      ),
    );
  }

  // Page transition animations
  static Widget pageTransition({
    required Widget child,
    required PageTransitionType type,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    switch (type) {
      case PageTransitionType.slideFromRight:
        return _SlideFromRightTransition(
          duration: duration,
          curve: curve,
          child: child,
        );
      case PageTransitionType.slideFromLeft:
        return _SlideFromLeftTransition(
          duration: duration,
          curve: curve,
          child: child,
        );
      case PageTransitionType.fadeIn:
        return _FadeInTransition(
          duration: duration,
          curve: curve,
          child: child,
        );
      case PageTransitionType.scaleIn:
        return _ScaleInTransition(
          duration: duration,
          curve: curve,
          child: child,
        );
      case PageTransitionType.rotation:
        return _RotationTransition(
          duration: duration,
          curve: curve,
          child: child,
        );
    }
  }
}

enum PageTransitionType {
  slideFromRight,
  slideFromLeft,
  fadeIn,
  scaleIn,
  rotation,
}

// Animated Slide In Widget
class AnimatedSlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset offset;
  final Curve curve;

  const AnimatedSlideIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.3),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedSlideIn> createState() => _AnimatedSlideInState();
}

class _AnimatedSlideInState extends State<AnimatedSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

// Morphing Button Widget
class _MorphingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final Curve curve;

  const _MorphingButton({
    required this.child,
    required this.onTap,
    required this.duration,
    required this.curve,
  });

  @override
  State<_MorphingButton> createState() => _MorphingButtonState();
}

class _MorphingButtonState extends State<_MorphingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

// Animated Floating Action Button
class _AnimatedFloatingActionButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Duration animationDuration;

  const _AnimatedFloatingActionButton({
    required this.child,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 6.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<_AnimatedFloatingActionButton> createState() => _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState extends State<_AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    HapticFeedback.mediumImpact();
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: FloatingActionButton(
              onPressed: _handlePress,
              tooltip: widget.tooltip,
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              elevation: widget.elevation,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

// Shake Animation Widget
class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool shouldShake;
  final Duration duration;

  const _ShakeAnimation({
    required this.child,
    required this.shouldShake,
    required this.duration,
  });

  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void didUpdateWidget(_ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldShake && !oldWidget.shouldShake) {
      _controller.forward().then((_) {
        _controller.reset();
      });
    }
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
        return Transform.translate(
          offset: Offset(
            _animation.value * 10 * (widget.shouldShake ? 1 : 0),
            0,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Pulse Animation Widget
class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.minScale,
    required this.maxScale,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
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
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Bounce Animation Widget
class _BounceAnimation extends StatefulWidget {
  final Widget child;
  final bool shouldBounce;
  final Duration duration;

  const _BounceAnimation({
    required this.child,
    required this.shouldBounce,
    required this.duration,
  });

  @override
  State<_BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<_BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(_BounceAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldBounce && !oldWidget.shouldBounce) {
      _controller.forward().then((_) {
        _controller.reset();
      });
    }
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
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Page Transition Widgets
class _SlideFromRightTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _SlideFromRightTransition({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: curve,
      )),
      child: child,
    );
  }
}

class _SlideFromLeftTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _SlideFromLeftTransition({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: curve,
      )),
      child: child,
    );
  }
}

class _FadeInTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _FadeInTransition({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: curve,
      )),
      child: child,
    );
  }
}

class _ScaleInTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _ScaleInTransition({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: curve,
      )),
      child: child,
    );
  }
}

class _RotationTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _RotationTransition({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: curve,
      )),
      child: child,
    );
  }
}
