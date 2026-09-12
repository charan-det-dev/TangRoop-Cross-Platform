import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Shared "Adjustment Slider" row: label + % + reset button + slider.
class AdjustmentSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min, max, defaultValue;
  final ValueChanged<double> onValueChange;

  const AdjustmentSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onValueChange,
    this.min = 0,
    this.max = 1,
    this.defaultValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              Text('${(value * 100).round()}%',
                  style: const TextStyle(
                      color: primaryPink,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              if (value != defaultValue)
                GestureDetector(
                  onTap: () => onValueChange(defaultValue),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.refresh,
                        size: 16, color: Colors.grey),
                  ),
                ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primaryPink,
              inactiveTrackColor: sliderTrackLight,
              thumbColor: primaryPink,
              trackHeight: 3,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onValueChange,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small circular sub-tool tab (icon over label).
class SubToolTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const SubToolTab({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? tabSelectedBackground : const Color(0xFFF3F4F6),
              border: selected ? Border.all(color: primaryPink) : null,
            ),
            child: Icon(icon,
                size: 22,
                color: selected ? tabSelectedText : textPrimaryDark),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? tabSelectedText : textPrimaryDark,
              )),
        ],
      ),
    );
  }
}
