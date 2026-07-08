import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme/app_theme.dart';
import 'neumorphic.dart';

/// A single post row rendered as a soft-UI card. Displays a numbered
/// accent badge, the post title and a truncated preview of its body.
class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, required this.onTap});

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: onTap,
        child: NeuBox(
          borderRadius: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  gradient: AppColors.accentGradient,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '#${post.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleCase(post.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.body.replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
