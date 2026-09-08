import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'main_navigation_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.8;

  // Slow breathing glow + gentle float
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  // Continuous ring rotation
  late final AnimationController _orbitController;

  // Fast flicker for the flame
  late final AnimationController _flameController;

  // Rising particles
  late final AnimationController _particleController;
  final List<_Particle> _particles = List.generate(
    14,
    (i) => _Particle.random(i),
  );

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _startAnimation();
    _navigateToHome();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _orbitController.dispose();
    _flameController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _scale = 1.0;
        });
      }
    });
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 5500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainNavigationPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    final Color glowOuter = isLight
        ? Color.lerp(colorScheme.tertiary, Colors.deepOrange, 0.3)!
        : Color.lerp(colorScheme.tertiary, Colors.cyanAccent, 0.18)!;
    final Color glowInner = isLight
        ? Color.lerp(colorScheme.primary, Colors.deepPurple, 0.25)!
        : Color.lerp(colorScheme.primary, Colors.purpleAccent, 0.25)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Ambient background wash
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = _pulse.value;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.2),
                      radius: 1.2,
                      colors: [
                        glowOuter.withValues(
                          alpha: isLight
                              ? lerpDouble(0.08, 0.14, t)!
                              : lerpDouble(0.10, 0.18, t)!,
                        ),
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Rising twinkling particles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    progress: _particleController.value,
                    color: isLight ? glowInner : glowOuter,
                  ),
                );
              },
            ),
          ),

          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOut,
              opacity: _opacity,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutBack,
                scale: _scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _pulse,
                        _orbitController,
                        _flameController,
                      ]),
                      builder: (context, child) {
                        final t = _pulse.value;
                        final outerBlur = lerpDouble(
                          isLight ? 34 : 26,
                          isLight ? 56 : 46,
                          t,
                        )!;
                        final outerSpread = lerpDouble(
                          isLight ? 4 : 2,
                          isLight ? 12 : 9,
                          t,
                        )!;
                        final outerAlpha = isLight
                            ? lerpDouble(0.28, 0.48, t)!
                            : lerpDouble(0.38, 0.65, t)!;
                        final float = lerpDouble(0, -6, t)!;
                        final flameT = _flameController.value;

                        return Transform.translate(
                          offset: Offset(0, float),
                          child: SizedBox(
                            width: 220,
                            height: 220,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Wide ambient halo (light mode gets extra help)
                                if (isLight)
                                  Container(
                                    width: 210,
                                    height: 210,
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

                                // Glow disc behind everything
                                Container(
                                  width: 148,
                                  height: 148,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: isLight
                                          ? [glowInner, glowOuter]
                                          : [
                                              colorScheme.primary.withValues(
                                                alpha: 0.28,
                                              ),
                                              glowOuter.withValues(alpha: 0.55),
                                            ],
                                    ),
                                    border: Border.all(
                                      color: isLight
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : Color.lerp(
                                              colorScheme.tertiary,
                                              Colors.white,
                                              0.6,
                                            )!.withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: glowOuter.withValues(
                                          alpha: outerAlpha,
                                        ),
                                        blurRadius: outerBlur,
                                        spreadRadius: outerSpread,
                                      ),
                                      BoxShadow(
                                        color: glowInner.withValues(
                                          alpha: isLight
                                              ? lerpDouble(0.18, 0.32, t)!
                                              : lerpDouble(0.28, 0.5, t)!,
                                        ),
                                        blurRadius: 18,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),

                                // Rotating dashed orbit ring
                                Transform.rotate(
                                  angle: _orbitController.value * 2 * pi,
                                  child: CustomPaint(
                                    size: const Size(190, 190),
                                    painter: _OrbitRingPainter(
                                      color: (isLight ? glowInner : glowOuter)
                                          .withValues(alpha: 0.55),
                                    ),
                                  ),
                                ),

                                // Small orbiting spark
                                Transform.rotate(
                                  angle: _orbitController.value * 2 * pi,
                                  child: Align(
                                    alignment: const Alignment(0, -1.02),
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: gold.withValues(alpha: 0.8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: gold.withValues(alpha: 0.8),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Flickering flame, layered behind/below the rocket image
                                Positioned(
                                  bottom: 18,
                                  child: Opacity(
                                    opacity: lerpDouble(0.75, 1.0, flameT)!,
                                    child: Transform.scale(
                                      scale: lerpDouble(0.9, 1.08, flameT)!,
                                      child: Container(
                                        width: 26,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [gold, orangeDark],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: orangeDark.withValues(
                                                alpha: 0.6,
                                              ),
                                              blurRadius: 16,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // The rocket artwork itself
                                child!,
                              ],
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/splash_rocket.png',
                        width: 108,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      'The Startup Idea',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          LinearGradient(colors: [glowInner, glowOuter])
                              .createShader(bounds),
                      child: Text(
                        'Evaluator by Yogesh',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 56),

                    SizedBox(
                      width: 36,
                      height: 36,
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, _) {
                          return ShaderMask(
                            shaderCallback: (bounds) => SweepGradient(
                              colors: [
                                glowInner.withValues(alpha: 0.0),
                                glowInner,
                                glowOuter,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ).createShader(bounds),
                            child: const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const Color gold = Color(0xFFFFC65B);
const Color orangeDark = Color(0xFFE85D25);

/// Dashed circular ring, drawn once and rotated by the parent Transform.
class _OrbitRingPainter extends CustomPainter {
  final Color color;
  _OrbitRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const dashCount = 28;
    const gapFraction = 0.55;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (2 * pi / dashCount) * i;
      final sweep = (2 * pi / dashCount) * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitRingPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _Particle {
  final double x;
  final double startY;
  final double size;
  final double speed;
  final double phase;

  _Particle({
    required this.x,
    required this.startY,
    required this.size,
    required this.speed,
    required this.phase,
  });

  factory _Particle.random(int seed) {
    final rnd = Random(seed * 97 + 13);
    return _Particle(
      x: rnd.nextDouble(),
      startY: rnd.nextDouble(),
      size: 1.5 + rnd.nextDouble() * 2.5,
      speed: 0.6 + rnd.nextDouble() * 0.8,
      phase: rnd.nextDouble() * 2 * pi,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress; // 0..1 looping
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final travelled = (p.startY - progress * p.speed) % 1.0;
      final y = travelled < 0 ? travelled + 1.0 : travelled;

      final twinkle = (sin(progress * 2 * pi * 3 + p.phase) + 1) / 2;
      final opacity = 0.15 + twinkle * 0.55;

      final paint = Paint()..color = color.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
