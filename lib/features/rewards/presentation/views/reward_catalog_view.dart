import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/rewards/presentation/controllers/reward_controller.dart';
import 'package:sortirin/shared/widgets/app_button.dart';
import 'package:sortirin/shared/widgets/empty_state_widget.dart';
import 'package:sortirin/shared/widgets/error_state_widget.dart';

/// Reward catalog with category filter, point cost, and redeem action.
class RewardCatalogView extends StatelessWidget {
  const RewardCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RewardController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Reward'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Penukaran',
            onPressed: () {
              controller.loadHistory();
              Get.toNamed('/rewards/history');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (controller.errorMessage.isNotEmpty) {
          return ErrorStateWidget(
            message: controller.errorMessage.value,
            onRetry: () => controller.loadRewards(),
          );
        }

        final displayRewards = controller.filteredRewards;
        if (displayRewards.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.card_giftcard,
            title: 'Belum ada reward',
            subtitle: 'Reward akan segera tersedia',
          );
        }

        return Column(
          children: [
            // Category filter chips
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: controller.categories.map((cat) {
                  final isSelected = controller.selectedCategory.value == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.sm),
                    child: ChoiceChip(
                      label: Text(
                        cat == 'all' ? 'Semua' : cat,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceLight,
                      onSelected: (_) => controller.selectedCategory.value = cat,
                    ),
                  );
                }).toList(),
              ),
            ),
            // Reward grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSizes.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: displayRewards.length,
                itemBuilder: (context, index) {
                  final reward = displayRewards[index];
                  return _RewardCard(
                    name: reward.name,
                    description: reward.description,
                    imageUrl: reward.imageUrl,
                    pointsCost: reward.pointsCost,
                    isOutOfStock: reward.isOutOfStock,
                    onRedeem: () => _showRedeemDialog(context, controller, reward.id, reward.name, reward.pointsCost),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showRedeemDialog(BuildContext context, RewardController controller, int rewardId, String name, int cost) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Tukarkan Poin'),
        content: Text('Tukarkan $cost poin untuk $name?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          Obx(() => AppButton(
                label: controller.isRedeeming.value ? 'Memproses...' : 'Tukar',
                onPressed: controller.isRedeeming.value
                    ? null
                    : () async {
                        await controller.redeem(rewardId, cost);
                        Get.back();
                      },
              )),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String name;
  final String description;
  final String? imageUrl;
  final int pointsCost;
  final bool isOutOfStock;
  final VoidCallback onRedeem;

  const _RewardCard({
    required this.name,
    required this.description,
    this.imageUrl,
    required this.pointsCost,
    this.isOutOfStock = false,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusMd)),
              ),
              child: Center(
                child: Icon(
                  Icons.card_giftcard,
                  size: 40,
                  color: isOutOfStock ? AppColors.textMuted : AppColors.primary,
                ),
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyles.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(description, style: TextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSizes.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.primary, size: 16),
                        const SizedBox(width: 4),
                        Text('$pointsCost', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (isOutOfStock)
                      const Text('Habis', style: TextStyle(color: AppColors.error, fontSize: 11))
                    else
                      SizedBox(
                        height: 28,
                        child: AppButton(
                          label: 'Tukar',
                          onPressed: onRedeem,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
