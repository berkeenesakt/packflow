import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Text(text),
    );
  }
}
