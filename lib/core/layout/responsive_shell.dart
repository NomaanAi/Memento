import 'package:flutter/material.dart';

import 'mobile_shell.dart';
import 'tablet_shell.dart';
import 'desktop_shell.dart';

class ResponsiveShell extends StatelessWidget {
  final Widget child;

  const ResponsiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileShell(child: child);
        } else if (constraints.maxWidth < 1024) {
          return TabletShell(child: child);
        } else {
          return DesktopShell(child: child);
        }
      },
    );
  }
}
