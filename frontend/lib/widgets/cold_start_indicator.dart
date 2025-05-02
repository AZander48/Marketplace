import 'package:flutter/material.dart';

class ColdStartIndicator extends StatelessWidget {
  final String message;
  final int attempt;
  final int maxRetries;

  const ColdStartIndicator({
    super.key,
    this.message = 'Server is starting up...',
    required this.attempt,
    required this.maxRetries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Attempt ${attempt + 1} of $maxRetries',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (attempt > 0) ...[
            const SizedBox(height: 8),
            Text(
              'This might take up to a minute on the first request',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 