import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'navigation_items.dart';

class MobileShell extends StatelessWidget {
  final Widget child;

  const MobileShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < appNavigationItems.length; i++) {
      if (location.startsWith(appNavigationItems[i].route)) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    context.go(appNavigationItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);

    // Limit to 4-5 items for mobile bottom nav
    final mobileItems = appNavigationItems.take(5).toList();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex < mobileItems.length ? currentIndex : 0,
          onDestinationSelected: (idx) => _onItemTapped(idx, context),
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          destinations: mobileItems.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              selectedIcon: Icon(
                item.activeIcon,
                color: theme.colorScheme.primary,
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
