import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class GlowingEmptyState extends StatefulWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;

  const GlowingEmptyState({
    super.key,
    required this.theme,
    required this.colorScheme,
  });

  @override
  State<GlowingEmptyState> createState() => GlowingEmptyStateState();
}

class GlowingEmptyStateState extends State<GlowingEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _glow = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final colorScheme = widget.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    final Color glowOuter = isLight
        ? Color.lerp(colorScheme.tertiary, Colors.deepOrange, 0.3)!
        : Color.lerp(colorScheme.tertiary, Colors.cyanAccent, 0.18)!;
    final Color glowInner = isLight
        ? Color.lerp(colorScheme.primary, Colors.deepPurple, 0.25)!
        : Color.lerp(colorScheme.primary, Colors.purpleAccent, 0.25)!;

    final List<Color> circleColors = isLight
        ? [glowInner, glowOuter]
        : [
            colorScheme.primary.withValues(alpha: 0.28),
            glowOuter.withValues(alpha: 0.55),
          ];

    final Color iconColor = isLight
        ? Colors.white
        : Color.lerp(colorScheme.primary, Colors.white, 0.35)!;

    final Color ringColor = isLight
        ? Colors.white.withValues(alpha: 0.8)
        : Color.lerp(
            colorScheme.tertiary,
            Colors.white,
            0.6,
          )!.withValues(alpha: 0.4);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _glow,
            builder: (context, child) {
              final t = _glow.value;

              final outerBlur = lerpDouble(
                isLight ? 34 : 26,
                isLight ? 56 : 46,
                t,
              )!;
              final outerSpread = lerpDouble(
                isLight ? 8 : 2,
                isLight ? 12 : 9,
                t,
              )!;
              final outerAlpha = isLight
                  ? lerpDouble(0.28, 0.48, t)!
                  : lerpDouble(0.38, 0.65, t)!;

              final innerBlur = lerpDouble(14, 20, t)!;
              final innerAlpha = isLight
                  ? lerpDouble(0.18, 0.32, t)!
                  : lerpDouble(0.28, 0.5, t)!;

              return Stack(
                alignment: Alignment.center,
                children: [
                 
                  if (isLight)
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            glowOuter.withValues(
                              alpha: lerpDouble(0.14, 0.22, t)!,
                            ),
                            glowOuter.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: circleColors,
                      ),
                      border: Border.all(color: ringColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: glowOuter.withValues(alpha: outerAlpha),
                          blurRadius: outerBlur,
                          spreadRadius: outerSpread,
                        ),
                        BoxShadow(
                          color: glowInner.withValues(alpha: innerAlpha),
                          blurRadius: innerBlur,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ],
              );
            },
            child: Icon(
              Icons.rocket_launch_outlined,
              size: 44,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 26),
          ShaderMask(
            shaderCallback: (bounds) =>
                LinearGradient(colors: [glowInner, glowOuter])
                    .createShader(bounds),
            child: Text(
              'No ideas submitted yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white, // masked by gradient
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to pitch your startup!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
