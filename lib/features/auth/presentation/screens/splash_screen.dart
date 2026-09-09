import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_state_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _minimumDelayPassed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();

    // Enforce an absolute minimum ~3 second display for the splash
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _minimumDelayPassed = true;
        });
        _checkAndProceed();
      }
    });
  }

  void _checkAndProceed() {
    if (!_minimumDelayPassed) return;

    final authState = ref.read(authStateProvider);
    if (authState == AuthState.initial || authState == AuthState.loading) {
      return;
    }

    if (authState == AuthState.authenticated) {
      context.go('/home');
    } else if (authState == AuthState.emailVerificationRequired) {
      context.go('/email-verification');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes so we can redirect if initialization finishes *after* the delay
    ref.listen(authStateProvider, (prev, next) {
      if (_minimumDelayPassed) {
        _checkAndProceed();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0B1020), // Deep midnight
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png', width: 120, height: 120),
                    const SizedBox(height: 24),
                    const Text(
                      'MEMENTO',
                      style: TextStyle(
                        color: Color(0xFFF8FAFC),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        fontFamily: 'Inter', // Assuming Inter is default via GoogleFonts
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A Digital Second Brain',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
