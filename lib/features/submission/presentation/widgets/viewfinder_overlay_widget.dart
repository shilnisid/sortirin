import 'package:flutter/material.dart';
import 'package:sortirin/core/constants/app_colors.dart';
import 'package:sortirin/core/constants/app_sizes.dart';

/// Viewfinder overlay with corner guides and grid lines.
class ViewfinderOverlay extends StatelessWidget {
  const ViewfinderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final rectWidth = size.width * 0.85;
    final rectHeight = rectWidth * 0.75;
    final left = (size.width - rectWidth) / 2;
    final top = (size.height - rectHeight) / 2;

    return Stack(
      children: [
        // Semi-transparent overlay
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.3)),
        ),
        // Clear scan area
        Positioned(
          left: left,
          top: top,
          child: Container(
            width: rectWidth,
            height: rectHeight,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
        // Corner guides
        _buildCorner(left, top, rectWidth, rectHeight),
      ],
    );
  }

  Widget _buildCorner(double left, double top, double w, double h) {
    return Stack(
      children: [
        // Top-left
        Positioned(
          left: left - 3,
          top: top - 3,
          child: _cornerPaint(Alignment.topLeft),
        ),
        // Top-right
        Positioned(
          left: left + w - 26,
          top: top - 3,
          child: _cornerPaint(Alignment.topRight),
        ),
        // Bottom-left
        Positioned(
          left: left - 3,
          top: top + h - 26,
          child: _cornerPaint(Alignment.bottomLeft),
        ),
        // Bottom-right
        Positioned(
          left: left + w - 26,
          top: top + h - 26,
          child: _cornerPaint(Alignment.bottomRight),
        ),
      ],
    );
  }

  Widget _cornerPaint(Alignment align) {
    return CustomPaint(
      size: const Size(26, 26),
      painter: _CornerPainter(align: align),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Alignment align;
  _CornerPainter({required this.align});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final w = size.width;
    final h = size.height;

    if (align == Alignment.topLeft) {
      path.moveTo(w, 0);
      path.lineTo(0, 0);
      path.lineTo(0, h);
    } else if (align == Alignment.topRight) {
      path.moveTo(0, 0);
      path.lineTo(w, 0);
      path.lineTo(w, h);
    } else if (align == Alignment.bottomLeft) {
      path.moveTo(w, h);
      path.lineTo(0, h);
      path.lineTo(0, 0);
    } else {
      path.moveTo(0, h);
      path.lineTo(w, h);
      path.lineTo(w, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => false;
}
