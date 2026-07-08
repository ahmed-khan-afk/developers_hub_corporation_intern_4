import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../theme/app_theme.dart';
import '../widgets/neu_avatar.dart';
import '../widgets/neumorphic.dart';

/// Task 2 (continued) — "Build a User Profile Screen":
/// Displays the user's name, email and avatar prominently, plus
/// secondary details (phone, website, company, address) in neat
/// neumorphic info rows.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeuButton(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: 14,
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      NeuAvatar(
                        imageUrl: user.avatarUrl,
                        initials: user.initials,
                        radius: 56,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${user.username}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      NeuBox(
                        style: NeuStyle.concave,
                        borderRadius: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.email_rounded, size: 14, color: AppColors.accentStart),
                            const SizedBox(width: 6),
                            Text(
                              user.email,
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _InfoRow(
                        icon: Icons.phone_rounded,
                        label: 'Phone',
                        value: user.phone,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.public_rounded,
                        label: 'Website',
                        value: user.website,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.location_on_rounded,
                        label: 'Address',
                        value: user.address.formatted,
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.business_center_rounded,
                        label: 'Company',
                        value: '${user.company.name}\n"${user.company.catchPhrase}"',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return NeuBox(
      borderRadius: 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
