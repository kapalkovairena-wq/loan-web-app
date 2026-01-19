import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Text(label),
    );
  }
}
