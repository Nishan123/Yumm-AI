import 'package:flutter/material.dart';

class CookbookErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String errorMessage;
  const CookbookErrorWidget({super.key, required this.onRetry, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.6,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(errorMessage,
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
        ),
    );
  }
}