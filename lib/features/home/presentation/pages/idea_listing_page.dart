import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_bloc.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_event.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_state.dart';
import 'package:startup_ideas/features/home/presentation/widgets/custom_appBar.dart';
import 'package:startup_ideas/features/home/presentation/widgets/glowing_empty_state.dart';

class IdeaListingPage extends StatelessWidget {
  const IdeaListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: const CustomAppbar(),
      ),
      body: BlocConsumer<IdeaBloc, IdeaState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colorScheme.inverseSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == IdeaStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3,
              ),
            );
          }
          if (state.ideas.isEmpty) {
            return GlowingEmptyState(theme: theme, colorScheme: colorScheme);
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: state.ideas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final idea = state.ideas[index];
              final isHighscore = idea.aiScore > 75;
              final scoreColors = isHighscore
                  ? [Colors.teal.shade400, Colors.green.shade600]
                  : [Colors.orange.shade400, Colors.amber.shade600];

              return Dismissible(
                key: Key(idea.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.delete_sweep_rounded,
                    color: theme.colorScheme.onErrorContainer,
                    size: 32,
                  ),
                ),
                onDismissed: (_) {
                  context.read<IdeaBloc>().add(DeleteIdeaEvent(idea.id));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isLight
                            ? colorScheme.primary.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Theme(
                      data: theme.copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: scoreColors,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: scoreColors.last.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            '${idea.aiScore}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          idea.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            idea.tagline,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: idea.hasVoted
                                  ? null
                                  : () => context.read<IdeaBloc>().add(
                                      UpvoteIdeaEvent(idea.id),
                                    ),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: idea.hasVoted ? 1.15 : 1.0,
                                  curve: Curves.easeOutBack,
                                  child: Icon(
                                    idea.hasVoted
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_alt_outlined,
                                    color: idea.hasVoted
                                        ? colorScheme.primary
                                        : colorScheme.outline,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${idea.votes}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: idea.hasVoted
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Divider with gradient fade, echoing the appbar's separator
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.outlineVariant.withValues(
                                          alpha: 0.0,
                                        ),
                                        colorScheme.outlineVariant.withValues(
                                          alpha: 0.6,
                                        ),
                                        colorScheme.outlineVariant.withValues(
                                          alpha: 0.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        colorScheme.secondaryContainer
                                            .withValues(
                                              alpha: isLight ? 0.9 : 0.5,
                                            ),
                                        colorScheme.tertiaryContainer
                                            .withValues(
                                              alpha: isLight ? 0.6 : 0.35,
                                            ),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: colorScheme.secondary.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: colorScheme.secondary
                                              .withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.auto_awesome,
                                          color: colorScheme.secondary,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'AI Verdict: "${idea.aiVerdict}"',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontStyle: FontStyle.italic,
                                                color: colorScheme
                                                    .onSecondaryContainer,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  idea.description,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          colorScheme.primary,
                                          colorScheme.tertiary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () => SharePlus.instance.share(
                                          ShareParams(
                                            text:
                                                'Check out "${idea.name}" on the Idea Evaluator: ${idea.tagline}!',
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.share_rounded,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Share Pitch',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
