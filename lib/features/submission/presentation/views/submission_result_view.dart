import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/submission/presentation/controllers/submission_controller.dart';
import 'package:sortirin/shared/widgets/app_button.dart';

/// Step 3: Review submission result & points breakdown.
class SubmissionResultView extends StatelessWidget {
  const SubmissionResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmissionController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.status.value == 'pending_review' ||
                      controller.status.value == 'uploading'
                  ? 'Mengirim...'
                  : 'Review',
            )),
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final status = controller.status.value;

        if (status == 'failed') {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: AppSizes.md),
                  Text('Gagal mengirim', style: TextStyles.titleLarge),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Coba periksa koneksi internetmu dan kirim ulang.',
                    style: TextStyles.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  AppButton(
                    label: 'Kirim Ulang',
                    onPressed: () {
                      controller.reset();
                      Get.offAllNamed('/submission/select');
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.md),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: status == 'pending_review'
                    ? const Icon(Icons.check_circle, size: 72, color: AppColors.primary)
                    : const SizedBox(
                        width: 72,
                        height: 72,
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 3,
                        ),
                      ),
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                status == 'pending_review' ? 'Terkirim!' : 'Mengupload...',
                style: TextStyles.titleLarge!,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                status == 'pending_review'
                    ? 'Video sedang divalidasi AI.\nKamu akan dapat notifikasi setelah selesai.'
                    : 'Harap tunggu, jangan tinggalkan halaman ini.',
                style: TextStyles.bodyMedium?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.lg),

              if (controller.selectedWasteTypes.isNotEmpty) ...[
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
                      Text('Rincian Poin', style: TextStyles.titleMedium),
                      const SizedBox(height: AppSizes.sm),
                      ...controller.selectedWasteTypes.map((item) {
                        final qty = item['quantity'] as int? ?? 1;
                        final base = item['basePoints'] as int? ?? 0;
                        final name = item['name'] as String? ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.xs),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$name x$qty', style: TextStyles.bodyMedium),
                              Text('${base * qty}', style: TextStyles.bodyMedium),
                            ],
                          ),
                        );
                      }),
                      const Divider(color: AppColors.surface),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimasi Poin', style: TextStyles.titleMedium),
                          Text(
                            '${controller.estimatedPoints}',
                            style: TextStyles.titleMedium?.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.lg),

              if (status == 'pending_review')
                Column(
                  children: [
                    AppButton(
                      label: 'Ke Dashboard',
                      onPressed: () {
                        controller.reset();
                        Get.offAllNamed('/dashboard');
                      },
                    ),
                    const SizedBox(height: AppSizes.sm),
                    TextButton(
                      onPressed: () {
                        controller.reset();
                        Get.offAllNamed('/submission/select');
                      },
                      child: const Text('Pilah Lagi'),
                    ),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}
