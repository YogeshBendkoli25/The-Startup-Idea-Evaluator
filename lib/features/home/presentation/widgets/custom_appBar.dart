import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_bloc.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_event.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_state.dart';
import 'package:startup_ideas/features/home/presentation/cubit/theme_cubit.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double titleFontSize;
  final bool showIconPrefixIcon;
  final bool showDarkModeToggle;
  final bool showSortMenu;
  final bool titleCentered;

  const CustomAppbar({
    super.key,
    this.title = 'Explore Pitches',
    this.titleFontSize = 21,
    this.showIconPrefixIcon = true,
    this.showDarkModeToggle = true,
    this.showSortMenu = true,
    this.titleCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    final containerAlpha = isLight ? 0.9 : 0.7;
    final containerAlphaLow = isLight ? 0.55 : 0.3;
    final borderAlpha = isLight ? 0.06 : 0.1;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 6,
      shadowColor: colorScheme.primary.withValues(alpha: isLight ? 0.1 : 0.15),
      centerTitle: titleCentered,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: colorScheme.surfaceTint,
      titleSpacing: 16,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          showIconPrefixIcon
              ? BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    final isDark = themeMode == ThemeMode.dark;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOutCubic,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [colorScheme.tertiary, colorScheme.primary]
                              : [colorScheme.primary, colorScheme.tertiary],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(
                              alpha: isDark ? 0.4 : 0.25,
                            ),
                            blurRadius: isDark ? 16 : 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) => RotationTransition(
                          turns: Tween<double>(
                            begin: 0.75,
                            end: 1,
                          ).animate(anim),
                          child: ScaleTransition(scale: anim, child: child),
                        ),
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          key: ValueKey(isDark),
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    );
                  },
                )
              : SizedBox.shrink(),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [colorScheme.primary, colorScheme.tertiary],
            ).createShader(bounds),
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: titleFontSize,
                letterSpacing: -0.4,
                color: Colors.white, // masked by gradient
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Theme toggle
        showDarkModeToggle
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.secondaryContainer.withValues(
                        alpha: containerAlpha,
                      ),
                      colorScheme.secondaryContainer.withValues(
                        alpha: containerAlphaLow,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isLight
                        ? colorScheme.secondary.withValues(alpha: 0.15)
                        : colorScheme.outline.withValues(alpha: borderAlpha),
                  ),
                  boxShadow: isLight
                      ? [
                          BoxShadow(
                            color: colorScheme.secondary.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    final isDark = themeMode == ThemeMode.dark;
                    return IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) =>
                            RotationTransition(turns: anim, child: child),
                        child: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          key: ValueKey(isDark),
                          color: isDark
                              ? Colors.amber.shade600
                              : colorScheme.onSecondaryContainer,
                          size: 22,
                        ),
                      ),
                      tooltip: 'Toggle Theme',
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    );
                  },
                ),
              )
            : SizedBox.shrink(),
        const SizedBox(width: 8),
        // Sort menu
        showSortMenu
            ? Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primaryContainer.withValues(
                        alpha: containerAlpha,
                      ),
                      colorScheme.tertiaryContainer.withValues(
                        alpha: isLight ? 0.6 : 0.4,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isLight
                        ? colorScheme.primary.withValues(alpha: 0.15)
                        : colorScheme.outline.withValues(alpha: borderAlpha),
                  ),
                  boxShadow: isLight
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: BlocBuilder<IdeaBloc, IdeaState>(
                  builder: (context, state) {
                    return PopupMenuButton<bool>(
                      icon: Icon(
                        Icons.sort_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: 22,
                      ),
                      tooltip: 'Sort Ideas',
                      position: PopupMenuPosition.under,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (sortByVotes) => context.read<IdeaBloc>().add(
                        SortIdeasEvent(sortByVotes: sortByVotes),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: true,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.thumb_up_outlined,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Sort by Votes'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: false,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.auto_awesome_outlined,
                                  size: 18,
                                  color: Colors.purple.shade400,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Sort by AI Score'),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            : SizedBox.shrink(),
      ],
      // Gradient separation line at the bottom of the appbar
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);
}
