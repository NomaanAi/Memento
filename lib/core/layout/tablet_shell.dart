import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'navigation_items.dart';
import '../theme/app_spacing.dart';

class TabletShell extends StatelessWidget {
  final Widget child;

  const TabletShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < appNavigationItems.length; i++) {
      if (location.startsWith(appNavigationItems[i].route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              context.go(appNavigationItems[index].route);
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: theme.colorScheme.surface,
            indicatorColor: theme.colorScheme.primaryContainer,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
              child: Image.asset('assets/logo.png', width: 32, height: 32),
            ),
            destinations: appNavigationItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(
                  item.activeIcon,
                  color: theme.colorScheme.primary,
                ),
                label: Text(item.label),
              );
            }).toList(),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.l),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      // context.go('/settings'); // Todo implement settings
                    },
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
