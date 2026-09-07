import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/features/auth/presentation/screens/splash_screen.dart';
import 'package:memento/features/auth/presentation/screens/login_screen.dart';
import 'package:memento/features/auth/presentation/screens/signup_screen.dart';
import 'package:memento/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:memento/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:memento/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:memento/features/projects/presentation/screens/projects_screen.dart';
import 'package:memento/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:memento/features/notes/presentation/screens/notes_screen.dart';
import 'package:memento/features/search/presentation/screens/search_screen.dart';
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authStateProvider,
      (previous, next) => notifyListeners(),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/email-verification',
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const ProjectsScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: '/notes',
        builder: (context, state) => const NotesScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      switch (authState) {
        case AuthState.initial:
        case AuthState.loading:
          // Stay on current route or splash if we are initializing
          if (state.matchedLocation == '/splash') return null;
          // If we are already doing something, don't interrupt. Usually loading state shouldn't redirect heavily unless it's initial load.
          return null;
        case AuthState.unauthenticated:
        case AuthState.error:
          return isAuthRoute ? null : '/login';
        case AuthState.emailVerificationRequired:
          if (state.matchedLocation == '/email-verification') return null;
          return '/email-verification';
        case AuthState.authenticated:
          if (isAuthRoute || state.matchedLocation == '/splash' || state.matchedLocation == '/email-verification') {
            return '/home';
          }
          return null;
      }
    },
  );
});
