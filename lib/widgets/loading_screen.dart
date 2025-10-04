import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  final String? message;
  
  const LoadingScreen({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary, // Exact orange from web app
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.celebration,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary, // Exact orange from web app
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
