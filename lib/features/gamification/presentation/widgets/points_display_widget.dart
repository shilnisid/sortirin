import 'package:flutter/material.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/theme/text_styles.dart';

/// Total points with level badge.
class PointsDisplayWidget extends StatelessWidget {
  final int totalPoints;
  final int level;
  final int pointsUntilNextLevel;

  const PointsDisplayWidget({
    super.key,
    required this.totalPoints,
    required this.level,
    required this.pointsUntilNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final levelProgress = level * 100;
    final nextLevel = (level + 1) * 100;
    final progress = levelProgress > 0
        ? (totalPoints - levelProgress) / (nextLevel - levelProgress).toDouble()
        : totalPoints / 100.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.15), AppColors.primaryDark.withValues(alpha: 0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.primary, size: 32),
              const SizedBox(width: 8),
              Text(
                '$totalPoints',
                style: TextStyles.pointsAmount,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  ' pts',
                  style: TextStyles.titleMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Level progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level $level', style: TextStyles.labelSmall),
              Text('$pointsUntilNextLevel pts ke Level ${level + 1}', style: TextStyles.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
