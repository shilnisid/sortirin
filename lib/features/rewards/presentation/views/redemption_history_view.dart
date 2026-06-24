import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/rewards/presentation/controllers/reward_controller.dart';
import 'package:sortirin/shared/widgets/empty_state_widget.dart';

/// Redemption history screen.
class RedemptionHistoryView extends StatelessWidget {
  const RedemptionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RewardController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Penukaran'),
        backgroundColor: AppColors.surface,
      ),
      body: Obx(() {
        if (controller.history.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.receipt_long,
            title: 'Belum ada penukaran',
            subtitle: 'Tukarkan poin untuk melihat riwayat',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: controller.history.length,
          itemBuilder: (context, index) {
            final item = controller.history[index];
            return Card(
              color: AppColors.surface,
              child: ListTile(
                leading: Icon(
                  item.status == 'approved' || item.status == 'fulfilled'
                      ? Icons.check_circle
                      : item.status == 'rejected'
                          ? Icons.cancel
                          : Icons.hourglass_empty,
                  color: item.status == 'approved' || item.status == 'fulfilled'
                      ? AppColors.primary
                      : item.status == 'rejected'
                          ? AppColors.error
                          : AppColors.warning,
                ),
                title: Text(item.rewardName, style: TextStyles.bodyMedium),
                subtitle: Text(
                  '${item.pointsSpent} poin — ${item.status}',
                  style: TextStyles.bodySmall,
                ),
                trailing: Text(
                  '${item.createdAt.day}/${item.createdAt.month}',
                  style: TextStyles.labelSmall,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
