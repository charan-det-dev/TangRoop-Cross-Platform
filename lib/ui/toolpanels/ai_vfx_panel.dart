import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'shared_widgets.dart';

class AICutoutToolPanel extends StatelessWidget {
  final String cutoutBgType;
  final Color cutoutSolidColor;
  final ValueChanged<String> onBgTypeSelected;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback onProcessCutout;

  const AICutoutToolPanel({
    super.key,
    required this.cutoutBgType,
    required this.cutoutSolidColor,
    required this.onBgTypeSelected,
    required this.onColorSelected,
    required this.onProcessCutout,
  });

  static const bgOptions = [
    ('None', 'Original', Icons.image),
    ('Transparent', 'PNG Cutout', Icons.content_cut),
    ('Solid', 'Solid Color', Icons.color_lens),
    ('Blur', 'Portrait Blur', Icons.blur_on),
  ];

  static const solidColors = [
    Colors.white,
    Colors.black,
    Color(0xFFFF4E88),
    Color(0xFF00E5FF),
    Color(0xFFFFD700),
    Color(0xFF9C27B0),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1-Tap AI Background Cutout',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onProcessCutout,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryPink,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Auto Cutout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: bgOptions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final (type, label, icon) = bgOptions[i];
                final isSelected = cutoutBgType == type;
                return GestureDetector(
                  onTap: () => onBgTypeSelected(type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? tabSelectedBackground
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: primaryPink, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected ? primaryPink : Colors.black87,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (cutoutBgType == 'Solid') ...[
            const SizedBox(height: 12),
            const Text(
              'Select Background Color',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 28,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: solidColors.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final color = solidColors[i];
                  final isSelected = cutoutSolidColor == color;
                  return GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? primaryPink : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class VFXToolPanel extends StatelessWidget {
  final String vfxName;
  final double vfxIntensity;
  final ValueChanged<String> onVfxSelected;
  final ValueChanged<double> onIntensityChange;

  const VFXToolPanel({
    super.key,
    required this.vfxName,
    required this.vfxIntensity,
    required this.onVfxSelected,
    required this.onIntensityChange,
  });

  static const vfxList = [
    ('None', 'None'),
    ('Vignette', 'Vignette'),
    ('Bokeh', 'Bokeh Blur'),
    ('Light Leak', 'Light Leak'),
    ('Film Grain', 'Film Grain'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special VFX & Shaders',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: vfxList.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (name, label) = vfxList[i];
              final isSelected = vfxName == name;
              return GestureDetector(
                onTap: () => onVfxSelected(name),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tabSelectedBackground
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: primaryPink, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryPink : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (vfxName != 'None') ...[
          const SizedBox(height: 10),
          AdjustmentSlider(
            label: '$vfxName Intensity',
            value: vfxIntensity,
            defaultValue: 0.5,
            onValueChange: onIntensityChange,
          ),
        ],
      ],
    );
  }
}
