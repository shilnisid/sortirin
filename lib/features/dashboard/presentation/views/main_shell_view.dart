import 'package:flutter/material.dart';
import 'package:sortirin/shared/widgets/app_bottom_nav.dart';
import 'package:sortirin/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:sortirin/features/rewards/presentation/views/reward_catalog_view.dart';
import 'package:sortirin/features/leaderboard/presentation/views/leaderboard_view.dart';
import 'package:sortirin/features/profile/presentation/views/profile_view.dart';

/// Shell with bottom navigation for main app sections.
class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  int _currentIndex = 0;

  final _pages = const [
    DashboardView(),
    RewardCatalogView(),
    LeaderboardView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
