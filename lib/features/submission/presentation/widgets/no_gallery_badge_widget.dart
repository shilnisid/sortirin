import 'package:flutter/material.dart';

/// "No Gallery" badge — visually indicates gallery access is blocked.
class NoGalleryBadge extends StatelessWidget {
  const NoGalleryBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.block, color: Colors.amber, size: 14),
          SizedBox(width: 4),
          Text(
            'No Gallery',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
