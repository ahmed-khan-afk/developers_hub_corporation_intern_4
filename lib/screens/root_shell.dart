import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'posts_screen.dart';
import 'users_screen.dart';

/// Hosts the two API-driven tabs (Posts / Users) behind a single shared
/// [ApiService] instance and a custom neumorphic bottom navigation bar.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final ApiService _apiService = ApiService();
  int _index = 0;

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PostsScreen(apiService: _apiService),
      UsersScreen(apiService: _apiService),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _NeuBottomNav(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _NeuBottomNav extends StatelessWidget {
  const _NeuBottomNav({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;

  static const _items = [
    (icon: Icons.article_rounded, label: 'Posts'),
    (icon: Icons.people_alt_rounded, label: 'Users'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withOpacity(0.5),
            offset: const Offset(6, 6),
            blurRadius: 16,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(-6, -6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final selected = i == index;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: selected ? AppColors.accentGradient : null,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 22,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                  if (selected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
