import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'shared_widgets.dart';

class CollageToolPanel extends StatelessWidget {
  final double spacing, cornerRadius;
  final ValueChanged<double> onSpacingChange, onCornerRadiusChange;
  final VoidCallback onPickCollagePhotos;

  const CollageToolPanel({
    super.key,
    required this.spacing,
    required this.cornerRadius,
    required this.onSpacingChange,
    required this.onCornerRadiusChange,
    required this.onPickCollagePhotos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(children: [
              Icon(Icons.grid_on, color: primaryPink, size: 18),
              SizedBox(width: 6),
              Text('Multi-Photo Collage Grid',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ]),
            GestureDetector(
              onTap: onPickCollagePhotos,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: primaryGradientColors),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(children: [
                  Icon(Icons.photo_library, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('Select 2-6 Photos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AdjustmentSlider(
            label: 'Grid Spacing',
            value: spacing,
            min: 0, max: 32, defaultValue: 16,
            onValueChange: onSpacingChange),
        AdjustmentSlider(
            label: 'Corner Radius',
            value: cornerRadius,
            min: 0, max: 48, defaultValue: 24,
            onValueChange: onCornerRadiusChange),
      ],
    );
  }
}
