import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

const List<NavigationItem> appNavigationItems = [
  NavigationItem(
    label: 'Home',
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard_rounded,
    route: '/home',
  ),
  NavigationItem(
    label: 'Projects',
    icon: Icons.folder_outlined,
    activeIcon: Icons.folder_rounded,
    route: '/projects',
  ),
  NavigationItem(
    label: 'Tasks',
    icon: Icons.check_circle_outline,
    activeIcon: Icons.check_circle_rounded,
    route: '/tasks',
  ),
  NavigationItem(
    label: 'Knowledge',
    icon: Icons.lightbulb_outline,
    activeIcon: Icons.lightbulb_rounded,
    route: '/notes', // Notes serve as knowledge base
  ),
  NavigationItem(
    label: 'Search',
    icon: Icons.search_outlined,
    activeIcon: Icons.search_rounded,
    route: '/search',
  ),
];
