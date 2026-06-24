import 'package:flutter/material.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/theme/text_styles.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peringkat')),
      body: Center(
        child: Text(
          'Leaderboard — Coming in M5',
          style: TextStyles.bodyLarge?.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
