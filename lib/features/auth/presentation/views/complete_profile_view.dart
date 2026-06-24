import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/constants/app_strings.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sortirin/shared/mixins/form_validation_mixin.dart';
import 'package:sortirin/shared/widgets/app_button.dart';

/// Complete profile screen — required before first submission.
class CompleteProfileView extends GetView<AuthController>
    with FormValidationMixin {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final cityController = TextEditingController();
    final districtController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.completeProfileTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.completeProfileDesc,
                  style: TextStyles.bodyLarge?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSizes.xl),
                // Phone number
                Text(AppStrings.phoneHint, style: TextStyles.labelLarge),
                const SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '0812xxxxxxx',
                    prefixText: '+62 ',
                  ),
                  validator: validPhone,
                ),
                const SizedBox(height: AppSizes.lg),
                // City
                Text(AppStrings.cityHint, style: TextStyles.labelLarge),
                const SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Jakarta Selatan',
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                // District
                Text(AppStrings.districtHint, style: TextStyles.labelLarge),
                const SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: districtController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Kebayoran Baru',
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                // Error
                Obx(() {
                  if (controller.errorMessage.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.md),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyles.bodyMedium?.copyWith(color: AppColors.error),
                    ),
                  );
                }),
                // Save button
                Obx(() => AppButton(
                      label: AppStrings.saveProfile,
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          controller.completeProfile(
                            phone: phoneController.text.trim(),
                            city: cityController.text.trim().isNotEmpty
                                ? cityController.text.trim()
                                : null,
                            district: districtController.text.trim().isNotEmpty
                                ? districtController.text.trim()
                                : null,
                          );
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
