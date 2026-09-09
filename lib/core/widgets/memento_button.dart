import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

enum ButtonType { primary, secondary, tertiary, destructive }

class MementoButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const MementoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
      case ButtonType.secondary:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderSide = BorderSide(color: colorScheme.primary, width: 2);
        break;
      case ButtonType.tertiary:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        break;
      case ButtonType.destructive:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        break;
    }

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s),
            child: Icon(icon, size: 20, color: foregroundColor),
          ),
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation:
              type == ButtonType.primary || type == ButtonType.destructive
              ? 2
              : 0,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.m),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
        ),
        child: content,
      ),
    );
  }
}
