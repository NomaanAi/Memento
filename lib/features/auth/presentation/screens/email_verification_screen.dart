import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/auth/presentation/providers/auth_provider.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:memento/core/widgets/memento_card.dart';
import 'package:memento/core/widgets/memento_button.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen>
    with WidgetsBindingObserver {
  bool _isLoading = false;
  bool _isSending = false;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onCheckVerification(silent: true);
    }
  }

  void _startCooldown() {
    setState(() => _cooldownSeconds = 30);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 0) {
        setState(() => _cooldownSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _onCheckVerification({bool silent = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    await ref.read(authStateProvider.notifier).reloadUser();

    if (mounted) {
      final authState = ref.read(authStateProvider);
      final isVerified = authState == AuthState.authenticated;

      if (!isVerified && !silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Your email is not verified yet. Please check your inbox and try again.',
            ),
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onResendEmail() async {
    if (_cooldownSeconds > 0 || _isSending) return;

    setState(() => _isSending = true);
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verification email sent. Check your inbox or spam folder.',
          ),
        ),
      );
      _startCooldown();
    } catch (e) {
      if (!mounted) return;
      final errorMessage = e.toString().contains('AuthenticationException')
          ? e.toString().replaceFirst('AuthenticationException: ', '')
          : e.toString();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to send verification email. $errorMessage'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _onSignOut() async {
    await ref.read(authStateProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _onSignOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: MementoCard(
              withAccent: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_unread,
                    size: 64,
                    color: Color(0xFFFBBF24),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verify your email address',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, child) {
                      final user = ref
                          .watch(authStateProvider.notifier)
                          .currentUser;
                      return Text(
                        'We sent a verification link to:\n\n${user?.email ?? 'your email'}\n\nCheck your inbox and spam folder.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  PrimaryAuthButton(
                    text: "I've verified my email",
                    onPressed: () => _onCheckVerification(silent: false),
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                  MementoButton(
                    label: _cooldownSeconds > 0
                        ? 'Resend available in ${_cooldownSeconds}s'
                        : 'Resend Verification Email',
                    onPressed: (_isSending || _cooldownSeconds > 0)
                        ? null
                        : _onResendEmail,
                    isLoading: _isSending,
                    type: ButtonType.secondary,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
