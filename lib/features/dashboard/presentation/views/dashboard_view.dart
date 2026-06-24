import 'package:flutter/material.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/theme/text_styles.dart';

/// Dashboard / Home screen — central hub of the app.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco_rounded, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Dashboard',
                style: TextStyles.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Coming in M5',
                style: TextStyles.bodyMedium?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
