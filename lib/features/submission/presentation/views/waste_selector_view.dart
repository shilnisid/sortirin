import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';
import 'package:sortirin/core/theme/text_styles.dart';
import 'package:sortirin/features/submission/presentation/controllers/submission_controller.dart';
import 'package:sortirin/features/submission/presentation/widgets/quantity_stepper_widget.dart';
import 'package:sortirin/features/submission/presentation/widgets/estimated_points_widget.dart';
import 'package:sortirin/shared/widgets/app_button.dart';

/// Step 1: Select waste types & quantities.
class WasteSelectorView extends StatelessWidget {
  const WasteSelectorView({super.key});

  // Sample waste type data — will be fetched from DB later
  static final List<Map<String, dynamic>> sampleWasteTypes = [
    {'id': 1, 'name': 'Sisa Makanan', 'category': 'Organik', 'basePoints': 5, 'icon': '🍚'},
    {'id': 2, 'name': 'Kardus', 'category': 'Kertas/Kardus', 'basePoints': 8, 'icon': '📦'},
    {'id': 3, 'name': 'Botol PET', 'category': 'Plastik Keras', 'basePoints': 12, 'icon': '🧴'},
    {'id': 4, 'name': 'Botol Kaca', 'category': 'Kaca/Beling', 'basePoints': 12, 'icon': '🍾'},
    {'id': 5, 'name': 'Kaleng Aluminium', 'category': 'Logam/Kaleng', 'basePoints': 15, 'icon': '🥫'},
    {'id': 6, 'name': 'Baterai', 'category': 'B3 Ringan', 'basePoints': 25, 'icon': '🔋'},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubmissionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Jenis Sampah'),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Text(
              'Pilih sampah yang kamu pilah di video ini\n(maks 5 jenis)',
              style: TextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Obx(() {
              final selected = controller.selectedWasteTypes;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                itemCount: sampleWasteTypes.length,
                itemBuilder: (context, index) {
                  final waste = sampleWasteTypes[index];
                  final isSelected = selected.any((s) => s['wasteTypeId'] == waste['id']);
                  final selectedItem = selected.firstWhereOrNull(
                    (s) => s['wasteTypeId'] == waste['id'],
                  );
                  final qty = selectedItem?['quantity'] as int? ?? 1;

                  return Card(
                    color: isSelected ? AppColors.surfaceLight : AppColors.surface,
                    child: ListTile(
                      leading: Text(waste['icon'] as String, style: const TextStyle(fontSize: 28)),
                      title: Text(waste['name'] as String, style: TextStyles.bodyMedium),
                      subtitle: Text(
                        '${waste['category']} — ${waste['basePoints']} pts/item',
                        style: TextStyles.bodySmall,
                      ),
                      trailing: isSelected
                          ? QuantityStepperWidget(
                              value: qty,
                              onChanged: (newQty) {
                                final items = [...controller.selectedWasteTypes];
                                final idx = items.indexWhere(
                                  (s) => s['wasteTypeId'] == waste['id'],
                                );
                                if (idx >= 0) {
                                  items[idx] = {
                                    ...items[idx],
                                    'quantity': newQty,
                                  };
                                  controller.updateSelectedItems(items);
                                }
                              },
                            )
                          : const Icon(Icons.add_circle_outline, color: AppColors.primary),
                      onTap: () {
                        if (isSelected) {
                          final items = controller.selectedWasteTypes
                              .where((s) => s['wasteTypeId'] != waste['id'])
                              .toList();
                          controller.updateSelectedItems(items);
                        } else if (selected.length < 5) {
                          final items = [...controller.selectedWasteTypes];
                          items.add({
                            'wasteTypeId': waste['id'],
                            'name': waste['name'],
                            'basePoints': waste['basePoints'],
                            'quantity': 1,
                          });
                          controller.updateSelectedItems(items);
                        }
                      },
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() => Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.surfaceLight)),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      EstimatedPointsWidget(points: controller.estimatedPoints),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: AppButton(
                          label: controller.selectedWasteTypes.isEmpty
                              ? 'Pilih sampah dulu'
                              : 'Rekam Video (${controller.selectedWasteTypes.length})',
                          onPressed: controller.selectedWasteTypes.isEmpty
                              ? null
                              : () => Get.toNamed('/submission/camera'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
