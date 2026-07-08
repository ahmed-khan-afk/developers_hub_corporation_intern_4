import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_exceptions.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neumorphic.dart';
import '../widgets/post_card.dart';
import '../widgets/status_views.dart';
import 'post_detail_screen.dart';

/// Task 1 — "HTTP Requests and JSON Parsing":
/// Fetches `/posts` from JSONPlaceholder via [ApiService], parses the
/// JSON into [Post] objects and renders them in a searchable ListView,
/// with full loading / error / empty states.
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key, required this.apiService});
  final ApiService apiService;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

enum _ViewState { loading, success, error }

class _PostsScreenState extends State<PostsScreen> {
  _ViewState _state = _ViewState.loading;
  List<Post> _allPosts = [];
  List<Post> _filtered = [];
  String _errorMessage = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _state = _ViewState.loading);
    try {
      final posts = await widget.apiService.fetchPosts();
      setState(() {
        _allPosts = posts;
        _filtered = posts;
        _state = _ViewState.success;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _state = _ViewState.error;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
        _state = _ViewState.error;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = query.trim().isEmpty
          ? _allPosts
          : _allPosts
              .where((p) =>
                  p.title.toLowerCase().contains(query.toLowerCase()) ||
                  p.body.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(count: _allPosts.length),
            const SizedBox(height: 18),
            NeuSearchField(
              controller: _searchController,
              onChanged: _onSearch,
              hint: 'Search posts…',
            ),
            const SizedBox(height: 18),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _ViewState.loading:
        return const LoadingView(message: 'Loading posts…');
      case _ViewState.error:
        return ErrorView(message: _errorMessage, onRetry: _load);
      case _ViewState.success:
        if (_filtered.isEmpty) {
          return const EmptyView(
            message: 'No posts match your search.',
            icon: Icons.search_off_rounded,
          );
        }
        return RefreshIndicator(
          onRefresh: _load,
          color: AppColors.accentStart,
          backgroundColor: AppColors.surface,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final post = _filtered[index];
              return PostCard(
                post: post,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PostDetailScreen(
                      post: post,
                      apiService: widget.apiService,
                    ),
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore Posts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count articles from JSONPlaceholder',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        const NeuBox(
          borderRadius: 16,
          padding: EdgeInsets.all(12),
          child: Icon(Icons.article_rounded, color: AppColors.accentStart),
        ),
      ],
    );
  }
}
