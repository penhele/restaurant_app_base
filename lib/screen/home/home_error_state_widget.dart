import 'package:flutter/material.dart';

class HomeErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const HomeErrorState({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_sharp,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text('Failed to load data'),
            Text('Check your connection!'),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
