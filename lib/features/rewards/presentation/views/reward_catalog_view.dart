import 'package:flutter/material.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/theme/text_styles.dart';

class RewardCatalogView extends StatelessWidget {
  const RewardCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Reward')),
      body: Center(
        child: Text(
          'Reward Catalog — Coming in M4',
          style: TextStyles.bodyLarge?.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
