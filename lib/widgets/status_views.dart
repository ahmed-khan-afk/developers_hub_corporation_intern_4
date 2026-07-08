import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'neumorphic.dart';

/// Full-screen loading state shown while an API call is in flight.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message = 'Fetching data…'});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeuBox(
            borderRadius: 100,
            padding: const EdgeInsets.all(28),
            child: const NeuLoadingIndicator(size: 14),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// Full-screen error state with a retry action — used whenever an
/// [ApiException] bubbles up from the service layer.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeuBox(
              borderRadius: 100,
              padding: const EdgeInsets.all(24),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.danger,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            NeuButton(
              filled: true,
              onTap: onRetry,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Try Again'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when a request succeeded but returned no items.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.message = 'Nothing to show here yet.',
    this.icon = Icons.inbox_rounded,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeuBox(
            borderRadius: 100,
            padding: const EdgeInsets.all(24),
            child: Icon(icon, color: AppColors.textSecondary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
