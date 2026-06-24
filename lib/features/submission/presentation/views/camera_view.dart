import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/submission/presentation/controllers/camera_controller.dart';
import 'package:sortirin/features/submission/presentation/widgets/viewfinder_overlay_widget.dart';
import 'package:sortirin/features/submission/presentation/widgets/no_gallery_badge_widget.dart';

/// Step 2: In-app camera — gallery blocked.
class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraController = Get.find<CameraController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!cameraController.isCameraReady.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: AppSizes.md),
                Text(
                  'Menyiapkan kamera...',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }
        return Stack(
          children: [
            // Camera preview — will be replaced by CameraPreview widget
            Container(color: Colors.black87),

            // Viewfinder overlay
            const ViewfinderOverlay(),

            // Top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Spacer(),
                      const NoGalleryBadge(),
                      const SizedBox(width: AppSizes.sm),
                      IconButton(
                        icon: Icon(
                          cameraController.flashMode.value
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                        ),
                        onPressed: () => cameraController.toggleFlash(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flip_camera_android, color: Colors.white),
                        onPressed: () => cameraController.toggleCamera(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    children: [
                      if (cameraController.isRecording.value)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                          ),
                          child: Obx(() => Text(
                                'REC ${cameraController.elapsedSeconds}s',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      const SizedBox(height: AppSizes.md),
                      GestureDetector(
                        onTap: () async {
                          if (cameraController.isRecording.value) {
                            await cameraController.stopRecording();
                            Get.toNamed('/submission/result');
                          } else {
                            await cameraController.startRecording();
                          }
                        },
                        child: Container(
                          width: AppSizes.recordButtonSize,
                          height: AppSizes.recordButtonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cameraController.isRecording.value
                                  ? Colors.red
                                  : Colors.white,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: cameraController.isRecording.value ? 28 : AppSizes.recordButtonInnerSize,
                              height: cameraController.isRecording.value ? 28 : AppSizes.recordButtonInnerSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cameraController.isRecording.value
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'Rekam 5–30 detik',
                        style: TextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
