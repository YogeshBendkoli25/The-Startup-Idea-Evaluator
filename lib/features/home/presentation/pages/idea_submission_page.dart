import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_ideas/core/utils/ai_evaluator.dart';
import 'package:startup_ideas/features/home/domain/entities/startup_ideas.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_bloc.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_event.dart';
import 'package:startup_ideas/features/home/presentation/widgets/appTextField.dart';
import 'package:startup_ideas/features/home/presentation/widgets/app_gradient_btn.dart';
import 'package:startup_ideas/features/home/presentation/widgets/custom_appBar.dart';
import 'package:uuid/uuid.dart';

class IdeaSubmissionPage extends StatefulWidget {
  final VoidCallback onSuccess;
  const IdeaSubmissionPage({super.key, required this.onSuccess});

  @override
  State<IdeaSubmissionPage> createState() => _IdeaSubmissionPageState();
}

class _IdeaSubmissionPageState extends State<IdeaSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _taglineCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _evaluating = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _taglineCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _evaluating = true);

    await Future.delayed(const Duration(milliseconds: 1400));
    final eval = AIEvaluator.evaluate(_nameCtrl.text, _descCtrl.text);

    if (!mounted) return;

    final newIdea = StartupIdea(
      id: const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      tagline: _taglineCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      aiScore: eval.score,
      aiVerdict: eval.verdict,
    );

    context.read<IdeaBloc>().add(SubmitIdeaEvent(newIdea));
    setState(() => _evaluating = false);

    _nameCtrl.clear();
    _taglineCtrl.clear();
    _descCtrl.clear();

    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        title: 'Pitch Your Startup',
        titleFontSize: 21,
        showIconPrefixIcon: false,
        showDarkModeToggle: false,
        showSortMenu: false,
        titleCentered: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(
                            alpha: isLight ? 0.25 : 0.4,
                          ),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.rocket_launch_rounded,
                      color: colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Got the next big idea?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fill in the details below and let our AI evaluate it.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              ThinOutlineBorder(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _nameCtrl,
                      label: 'Startup Name',
                      hint: 'e.g. Acme AI',
                      icon: Icons.storefront_rounded,
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _taglineCtrl,
                      label: 'Punchy Tagline',
                      hint: 'Uber for Developer Mentorship',
                      icon: Icons.bolt_rounded,
                    ),

                    const SizedBox(height: 18),

                    AppTextField(
                      controller: _descCtrl,
                      maxLines: 4,
                      label: 'Description',
                      hint: 'What problem are you solving and how?',
                      icon: Icons.description_rounded,
                      validator: (v) => v!.trim().length < 15
                          ? 'Minimum 15 characters required'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              HelperText(colorScheme: colorScheme, theme: theme),
              const SizedBox(height: 28),

              AppGradientButton(
                text: 'Evaluate with AI & Submit',
                loadingText: 'AI is calculating your burn rate...',
                icon: Icons.auto_awesome_rounded,
                isLoading: _evaluating,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelperText extends StatelessWidget {
  final ColorScheme colorScheme;
  final ThemeData theme;
  const HelperText({super.key, required this.colorScheme, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: colorScheme.outline,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Your idea will be scored by AI right after submission.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThinOutlineBorder extends StatelessWidget {
  final Widget child;

  const ThinOutlineBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? colorScheme.primary.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
