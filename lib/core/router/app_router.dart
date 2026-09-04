import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Login'))),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Register'))),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home'))),
      ),
      GoRoute(
        path: '/projects',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Projects'))),
      ),
      // TODO: Add routes for tasks, notes, documents, journal, goals, calendar, analytics, settings, profile
    ],
    // redirect: (context, state) {
    //   // TODO: implement auth guard
    //   return null;
    // },
  );
});
