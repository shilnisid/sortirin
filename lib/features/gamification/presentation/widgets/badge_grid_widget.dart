import 'package:flutter/material.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';

/// Badge grid for profile/dashboard — shows unlocked badges.
class BadgeGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> badges;
  final int maxDisplay;

  const BadgeGridWidget({
    super.key,
    required this.badges,
    this.maxDisplay = 6,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          children: [
            Icon(Icons.emoji_events_outlined, size: 40, color: AppColors.textMuted),
            const SizedBox(height: AppSizes.sm),
            Text('Belum ada badge', style: TextStyles.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSizes.xs),
            Text('Kumpulkan poin untuk membuka badge!', style: TextStyles.labelSmall),
          ],
        ),
      );
    }

    final displayBadges = badges.length > maxDisplay ? badges.sublist(0, maxDisplay) : badges;
    final hiddenCount = badges.length - maxDisplay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Badge Terkunci', style: TextStyles.titleMedium),
            const SizedBox(width: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${badges.length}', style: const TextStyle(color: AppColors.primary, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...displayBadges.map((badge) => _BadgeItem(
                  name: badge['name'] as String? ?? '',
                  icon: badge['icon'] as String? ?? '🏅',
                  isUnlocked: true,
                  points: badge['points_reward'] as int? ?? 0,
                )),
            if (hiddenCount > 0)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    '+$hiddenCount',
                    style: TextStyles.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String name;
  final String icon;
  final bool isUnlocked;
  final int points;

  const _BadgeItem({
    required this.name,
    required this.icon,
    required this.isUnlocked,
    this.points = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: name,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surfaceLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isUnlocked ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isUnlocked ? icon : '🔒', style: const TextStyle(fontSize: 20)),
              if (points > 0)
                Text(
                  '$points',
                  style: const TextStyle(color: AppColors.primary, fontSize: 8),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
