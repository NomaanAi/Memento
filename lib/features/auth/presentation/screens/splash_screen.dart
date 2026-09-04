import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Logo
            Icon(Icons.dashboard_rounded, size: 80, color: Colors.blue),
            SizedBox(height: 24),
            Text(
              'Memento',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            SizedBox(height: 8),
            Text(
              'Your Digital Second Brain',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
