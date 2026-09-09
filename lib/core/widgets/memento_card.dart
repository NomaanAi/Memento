import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class MementoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final bool withAccent;

  const MementoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.l),
    this.onTap,
    this.color,
    this.withAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget cardContent = Padding(padding: padding, child: child);

    if (withAccent) {
      cardContent = Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 4),
          ),
        ),
        child: cardContent,
      );
    }

    final card = Card(
      color: color ?? theme.cardTheme.color,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.m),
        child: cardContent,
      ),
    );

    return card;
  }
}
