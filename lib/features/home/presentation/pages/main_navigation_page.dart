import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_ideas/features/home/presentation/cubit/main_navigation_cubit.dart';

import 'idea_submission_page.dart';
import 'idea_listing_page.dart';
import 'leaderboard_page.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainNavigationCubit(),
      child: const _MainNavigationView(),
    );
  }
}

class _MainNavigationView extends StatelessWidget {
  const _MainNavigationView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<MainNavigationCubit, int>(
      builder: (context, currentIndex) {
        final pages = [
          IdeaSubmissionPage(
            onSuccess: () => context.read<MainNavigationCubit>().changeTab(1),
          ),
          const IdeaListingPage(),
          const LeaderboardPage(),
        ];

        return Scaffold(
          body: IndexedStack(index: currentIndex, children: pages),
          bottomNavigationBar: _GradientNavBar(
            currentIndex: currentIndex,
            onTap: (idx) => context.read<MainNavigationCubit>().changeTab(idx),
            theme: theme,
            colorScheme: colorScheme,
          ),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.icon, this.activeIcon, this.label);
}

class _GradientNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _GradientNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.theme,
    required this.colorScheme,
  });

  static const _items = [
    _NavItem(
      Icons.add_circle_outline_rounded,
      Icons.add_circle_rounded,
      'Pitch',
    ),
    _NavItem(Icons.list_alt_outlined, Icons.list_alt_rounded, 'Ideas'),
    _NavItem(Icons.leaderboard_outlined, Icons.leaderboard_rounded, 'Top 5'),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = theme.brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: isLight
                ? colorScheme.primary.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = index == currentIndex;
              final item = _items[index];

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.tertiary,
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: isLight ? 0.3 : 0.45,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            selected ? item.activeIcon : item.icon,
                            key: ValueKey(selected),
                            size: 24,
                            color: selected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
