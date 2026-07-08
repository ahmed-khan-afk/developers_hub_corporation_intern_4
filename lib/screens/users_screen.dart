import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/api_exceptions.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neu_avatar.dart';
import '../widgets/neumorphic.dart';
import '../widgets/status_views.dart';
import 'user_profile_screen.dart';

/// Task 2 — "Fetching and Displaying User Data":
/// Fetches `/users`, shows each as a soft-UI list row (avatar, name,
/// email) and pushes [UserProfileScreen] with the full detail on tap.
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key, required this.apiService});
  final ApiService apiService;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

enum _ViewState { loading, success, error }

class _UsersScreenState extends State<UsersScreen> {
  _ViewState _state = _ViewState.loading;
  List<AppUser> _users = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = _ViewState.loading);
    try {
      final users = await widget.apiService.fetchUsers();
      setState(() {
        _users = users;
        _state = _ViewState.success;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _state = _ViewState.error;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
        _state = _ViewState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Team Directory',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                NeuBox(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.people_alt_rounded, color: AppColors.accentStart),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap a user to view their full profile',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
        return const LoadingView(message: 'Loading team…');
      case _ViewState.error:
        return ErrorView(message: _errorMessage, onRetry: _load);
      case _ViewState.success:
        if (_users.isEmpty) return const EmptyView(message: 'No users found.');
        return RefreshIndicator(
          onRefresh: _load,
          color: AppColors.accentStart,
          backgroundColor: AppColors.surface,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UserProfileScreen(user: user)),
                  ),
                  child: NeuBox(
                    borderRadius: 20,
                    child: Row(
                      children: [
                        NeuAvatar(
                          imageUrl: user.avatarUrl,
                          initials: user.initials,
                          radius: 26,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      ],
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
