import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_bloc.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_state.dart';
import 'package:startup_ideas/features/home/presentation/widgets/leaderboar_empty_state.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: colorScheme.surfaceTint,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.amber.shade400, Colors.amber.shade700],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: isLight ? 0.3 : 0.45),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [colorScheme.primary, colorScheme.tertiary],
              ).createShader(bounds),
              child: Text(
                'Top 5 Leaderboard',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.0),
                  colorScheme.primary.withValues(alpha: isLight ? 0.5 : 0.6),
                  colorScheme.tertiary.withValues(alpha: isLight ? 0.5 : 0.6),
                  colorScheme.primary.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<IdeaBloc, IdeaState>(
        builder: (context, state) {
          final top5 = List.of(state.ideas)
            ..sort((a, b) => b.votes.compareTo(a.votes));
          final displayList = top5.take(5).toList();

          if (displayList.isEmpty) {
            return LeaderboardEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final idea = displayList[index];

           
              const rankStyles = [
                _RankStyle(
                  colors: [
                    Color.fromRGBO(255, 215, 106, 0.86),
                    Color.fromRGBO(232, 163, 23, 1),
                  ], // Gold
                  icon: Icons.emoji_events_rounded,
                  iconColor: Color.fromRGBO(255, 244, 214, 1),
                  scale: 1.0,
                ),
                _RankStyle(
                  colors: [
                    Color.fromRGBO(227, 230, 234, 1),
                    Color.fromRGBO(169, 176, 186, 1),
                  ], // Silver
                  icon: Icons.military_tech_rounded,
                  iconColor: Colors.white,
                  scale: 0.97,
                ),
                _RankStyle(
                  colors: [
                    Color.fromRGBO(224, 173, 124, 1),
                    Color.fromRGBO(173, 106, 56, 1),
                  ], // Bronze
                  icon: Icons.military_tech_rounded,
                  iconColor: Color.fromRGBO(255, 244, 214, 1),
                  scale: 0.95,
                ),
              ];

              final style = index < 3
                  ? rankStyles[index]
                  : const _RankStyle(
                      colors: [Color(0xFF3E4C59), Color(0xFF1F2933)],
                      icon: null,
                      iconColor: Colors.white70,
                      scale: 0.92,
                    );

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 350 + (index * 80)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: style.colors,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: style.colors.last.withValues(
                          alpha: index < 3 ? 0.35 : 0.2,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: index < 3
                        ? Border.all(
                            color: Colors.white.withValues(alpha: 0.40),
                          )
                        : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    leading: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white.withValues(alpha: 0.22),
                          child: Text(
                            '#${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (style.icon != null)
                          Positioned(
                            top: -8,
                            right: -8,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: style.colors.last,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 1.2,
                                ),
                              ),
                              child: Icon(
                                style.icon,
                                size: 13,
                                color: style.iconColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      idea.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Score: ${idea.aiScore}/100',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.thumb_up_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${idea.votes}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RankStyle {
  final List<Color> colors;
  final IconData? icon;
  final Color iconColor;
  final double scale;

  const _RankStyle({
    required this.colors,
    required this.icon,
    required this.iconColor,
    required this.scale,
  });
}
