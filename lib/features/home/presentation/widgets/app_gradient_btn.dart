import 'package:flutter/material.dart';

class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.loadingText = 'Please wait...',
    this.icon = Icons.auto_awesome_rounded,
    this.isLoading = false,
    this.height = 56,
    this.borderRadius = 16,
  });

  final VoidCallback? onPressed;
  final String text;
  final String loadingText;
  final IconData icon;
  final bool isLoading;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final primaryColor = colorScheme.primary;
    final tertiaryColor = colorScheme.tertiary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isLoading
              ? [
                  primaryColor.withValues(alpha: 0.6),
                  tertiaryColor.withValues(alpha: 0.6),
                ]
              : [primaryColor, tertiaryColor],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isLoading
            ? []
            : [
                BoxShadow(
                  color: primaryColor.withValues(alpha: isLight ? 0.3 : 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? _LoadingContent(
                      key: const ValueKey('loading'),
                      text: loadingText,
                      color: colorScheme.onPrimary,
                    )
                  : _ButtonContent(
                      key: const ValueKey('idle'),
                      text: text,
                      icon: icon,
                      color: colorScheme.onPrimary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: color),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
