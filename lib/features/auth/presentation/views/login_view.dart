import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/constants/app_strings.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sortirin/shared/widgets/app_button.dart';

/// Login screen — Google Sign-In as primary auth method.
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo / branding area
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                AppStrings.tagline,
                style: TextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Pilah sampah, dapatkan reward nyata.',
                style: TextStyles.bodyLarge?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              // Error message
              Obx(() {
                if (controller.errorMessage.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.md),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyles.bodyMedium?.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
              // Google sign-in button
              Obx(() => AppButton(
                    label: AppStrings.loginGoogleButton,
                    icon: Icons.g_mobiledata_rounded,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.signInWithGoogle,
                  )),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Dengan masuk, kamu menyetujui Syarat & Ketentuan dan Kebijakan Privasi kami.',
                style: TextStyles.labelSmall,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
