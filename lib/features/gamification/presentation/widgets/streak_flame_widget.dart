import 'package:flutter/material.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/theme/text_styles.dart';

/// Streak flame indicator (appears in dashboard header).
class StreakFlameWidget extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final double multiplier;
  final String label;

  const StreakFlameWidget({
    super.key,
    required this.currentStreak,
    this.longestStreak = 0,
    this.multiplier = 1.0,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    final hasStreak = currentStreak > 0;
    final flameSize = hasStreak ? (currentStreak >= 7 ? 32.0 : 24.0) : 20.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: hasStreak ? AppColors.warning.withValues(alpha: 0.12) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasStreak ? AppColors.warning.withValues(alpha: 0.3) : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasStreak ? Icons.local_fire_department : Icons.local_fire_department_outlined,
            color: hasStreak ? AppColors.warning : AppColors.textMuted,
            size: flameSize,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasStreak) ...[
                Text(
                  '$currentStreak',
                  style: TextStyles.streakFlame,
                ),
                if (multiplier > 1.0)
                  Text(
                    '${multiplier}x poin',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ] else ...[
                const Text(
                  '0',
                  style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold),
                ),
              ],
              Text(
                label.isNotEmpty ? label : (hasStreak ? 'streak' : 'belum ada streak'),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
