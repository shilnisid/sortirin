import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/core/network/supabase_client.dart';
import 'package:sortirin/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:sortirin/features/gamification/presentation/widgets/points_display_widget.dart';
import 'package:sortirin/features/gamification/presentation/widgets/streak_flame_widget.dart';

/// Profile & Settings screen.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final gamification = Get.find<GamificationController>();
    final user = SupabaseClientService.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.surface,
      ),
      body: Obx(() {
        if (gamification.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar & name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: Icon(Icons.person, size: 40, color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      user?.email ?? 'Pengguna Sortirin',
                      style: TextStyles.titleMedium,
                    ),
                    if (user?.email != null)
                      Text(user!.email!, style: TextStyles.bodySmall),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // Points & Streak
              PointsDisplayWidget(
                totalPoints: gamification.totalPoints.value,
                level: gamification.level.value,
                pointsUntilNextLevel: gamification.pointsUntilNextLevel.value,
              ),

              const SizedBox(height: AppSizes.md),

              StreakFlameWidget(
                currentStreak: gamification.currentStreak.value,
                longestStreak: gamification.longestStreak.value,
                multiplier: gamification.streakMultiplier.value,
              ),

              const SizedBox(height: AppSizes.lg),

              // Settings section
              Text('Pengaturan', style: TextStyles.titleMedium),
              const SizedBox(height: AppSizes.sm),

              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifikasi',
                subtitle: 'Push notification & pengingat',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.location_on_outlined,
                title: 'Lokasi',
                subtitle: 'GPS untuk validasi submission',
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                subtitle: 'v1.0.0',
                onTap: () {},
              ),

              const SizedBox(height: AppSizes.lg),

              // Sign out
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await SupabaseClientService.client.auth.signOut();
                    Get.offAllNamed('/onboarding');
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Keluar', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: TextStyles.bodyMedium),
        subtitle: Text(subtitle, style: TextStyles.bodySmall),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: AppColors.textMuted) : null),
        onTap: onTap,
      ),
    );
  }
}
