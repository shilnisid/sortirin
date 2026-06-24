import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:sortirin/features/gamification/presentation/widgets/points_display_widget.dart';
import 'package:sortirin/features/gamification/presentation/widgets/streak_flame_widget.dart';

/// Dashboard / Home screen — central hub with points, streak, quick actions.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final gamificationController = Get.find<GamificationController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (gamificationController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Halo, Pejuang Pilah!', style: TextStyles.titleLarge),
                        const SizedBox(height: 4),
                        Text('Ayo pilah sampah dan dapatkan reward', style: TextStyles.bodySmall),
                      ],
                    ),
                    // Streak widget
                    StreakFlameWidget(
                      currentStreak: gamificationController.currentStreak.value,
                      longestStreak: gamificationController.longestStreak.value,
                      multiplier: gamificationController.streakMultiplier.value,
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.lg),

                // Points display card
                PointsDisplayWidget(
                  totalPoints: gamificationController.totalPoints.value,
                  level: gamificationController.level.value,
                  pointsUntilNextLevel: gamificationController.pointsUntilNextLevel.value,
                ),

                const SizedBox(height: AppSizes.lg),

                // Quick actions
                Text('Aksi Cepat', style: TextStyles.titleMedium),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.videocam_rounded,
                        label: 'Pilah Sampah',
                        subtitle: 'Rekam & kirim',
                        color: AppColors.primary,
                        onTap: () => Get.toNamed('/submission/select'),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.emoji_events_rounded,
                        label: 'Tukar Poin',
                        subtitle: 'Lihat katalog',
                        color: AppColors.accent,
                        onTap: () => Get.toNamed('/rewards'),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.leaderboard_rounded,
                        label: 'Peringkat',
                        subtitle: 'Leaderboard',
                        color: AppColors.info,
                        onTap: () => Get.toNamed('/leaderboard'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.lg),

                // Streak info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Info Streak', style: TextStyles.titleMedium),
                      const SizedBox(height: AppSizes.sm),
                      Row(
                        children: [
                          _StreakStat(
                            label: 'Streak Saat Ini',
                            value: '${gamificationController.currentStreak.value}',
                            icon: Icons.local_fire_department,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: AppSizes.md),
                          _StreakStat(
                            label: 'Streak Terpanjang',
                            value: '${gamificationController.longestStreak.value}',
                            icon: Icons.trending_up,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        gamificationController.streakLabel,
                        style: TextStyles.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                      if (gamificationController.streakMultiplier.value > 1.0)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSizes.xs),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Text(
                              'Bonus ${gamificationController.streakMultiplier.value}x poin aktif!',
                              style: const TextStyle(
                                color: AppColors.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                // Badge info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Badge Terkumpul', style: TextStyles.titleMedium),
                    Text(
                      '${gamificationController.badgeCount.value} badge',
                      style: TextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSizes.xs),
            Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
            Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StreakStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: AppSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyles.titleLarge?.copyWith(color: color)),
              Text(label, style: TextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
