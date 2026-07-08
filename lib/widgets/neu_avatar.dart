import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A circular avatar with a soft "raised ring" neumorphic frame.
/// Falls back to initials on a gradient background if the network
/// image fails to load (or is still loading).
class NeuAvatar extends StatelessWidget {
  const NeuAvatar({
    super.key,
    required this.imageUrl,
    required this.initials,
    this.radius = 44,
  });

  final String imageUrl;
  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.55),
            offset: const Offset(5, 5),
            blurRadius: 12,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(-5, -5),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _fallback();
          },
          errorBuilder: (context, error, stack) => _fallback(),
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        gradient: AppColors.accentGradient,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
