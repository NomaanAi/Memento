import 'package:flutter/material.dart';
import 'package:memento/core/widgets/memento_text_field.dart';
import 'package:memento/core/widgets/memento_button.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // If suffixIcon is an IconButton, extract the icon and onTap for MementoTextField
    IconData? iconData;
    VoidCallback? onTap;

    if (suffixIcon is IconButton) {
      final btn = suffixIcon as IconButton;
      if (btn.icon is Icon) {
        iconData = (btn.icon as Icon).icon;
      }
      onTap = btn.onPressed;
    }

    return MementoTextField(
      controller: controller,
      label: label,
      hintText: hint,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      suffixIcon: iconData,
      onSuffixIconTap: onTap,
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.validator,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return MementoTextField(
      controller: widget.controller,
      label: widget.label,
      hintText: 'Enter your password',
      obscureText: _obscure,
      validator: widget.validator,
      onChanged: widget.onChanged,
      suffixIcon: _obscure ? Icons.visibility_off : Icons.visibility,
      onSuffixIconTap: () => setState(() => _obscure = !_obscure),
    );
  }
}

class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MementoButton(
      label: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: true,
      type: ButtonType.primary,
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MementoButton(
      label: 'Continue with Google',
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: true,
      type: ButtonType.secondary,
      icon: Icons.login, // Replace with google logo icon if available
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}
