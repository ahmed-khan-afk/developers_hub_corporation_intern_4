import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../models/post.dart';
import '../services/api_exceptions.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neu_avatar.dart';
import '../widgets/neumorphic.dart';
import 'user_profile_screen.dart';

/// Detail view for a single post. Also demonstrates a second, related
/// network call: it looks up the post's author (`/users/:id`) and shows
/// a small author chip that deep-links into [UserProfileScreen].
class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.post,
    required this.apiService,
  });

  final Post post;
  final ApiService apiService;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  AppUser? _author;
  bool _loadingAuthor = true;

  @override
  void initState() {
    super.initState();
    _loadAuthor();
  }

  Future<void> _loadAuthor() async {
    try {
      final user = await widget.apiService.fetchUserById(widget.post.userId);
      if (mounted) setState(() => _author = user);
    } on ApiException {
      // Non-critical — the post itself still renders without the author.
    } finally {
      if (mounted) setState(() => _loadingAuthor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NeuButton(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: 14,
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.arrow_back_rounded, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Post #${post.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title[0].toUpperCase() + post.title.substring(1),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAuthorChip(),
                      const SizedBox(height: 20),
                      NeuBox(
                        borderRadius: 20,
                        child: Text(
                          post.body[0].toUpperCase() + post.body.substring(1),
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
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

  Widget _buildAuthorChip() {
    if (_loadingAuthor) {
      return const NeuLoadingIndicator(size: 8);
    }
    if (_author == null) return const SizedBox.shrink();

    final author = _author!;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => UserProfileScreen(user: author)),
      ),
      child: NeuBox(
        style: NeuStyle.none,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeuAvatar(
              imageUrl: author.avatarUrl,
              initials: author.initials,
              radius: 16,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'View profile',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.accentStart.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
