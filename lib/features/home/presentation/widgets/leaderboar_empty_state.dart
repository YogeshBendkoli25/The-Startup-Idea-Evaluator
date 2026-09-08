import 'package:flutter/material.dart';

class LeaderboardEmptyState extends StatefulWidget {
  const LeaderboardEmptyState({super.key});

  @override
  State<LeaderboardEmptyState> createState() => _LeaderboardEmptyStateState();
}

class _LeaderboardEmptyStateState extends State<LeaderboardEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shineController;

  @override
  void initState() {
    super.initState();

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(period: const Duration(milliseconds: 3000));
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _shineController,
            builder: (context, child) {
              return Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.amber.withValues(alpha: 0.15),
                      colorScheme.tertiary.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: ClipOval(
                  child: Stack(
                    children: [
                      // Trophy icon
                      Center(
                        child: Icon(
                          Icons.emoji_events_outlined,
                          size: 44,
                          color: Colors.amber.shade700,
                        ),
                      ),

                      // Shine
                      Positioned.fill(
                        child: IgnorePointer(
                          child: FractionallySizedBox(
                            widthFactor: 0.35,
                            alignment: Alignment(
                              -3.0 + (_shineController.value * 6.0),
                              0,
                            ),
                            child: Transform.rotate(
                              angle: -0.23,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.20),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          Text(
            'No entries yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Vote for pitches to build the leaderboard!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
