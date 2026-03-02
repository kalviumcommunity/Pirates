import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SosButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const SosButton({
    super.key,
    required this.onPressed,
    this.label = 'SOS',
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Emergency SOS button',
      child: SizedBox(
        width: 220,
        height: 220,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.sosRed,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
          ),
        ),
      ),
    );
  }
}
