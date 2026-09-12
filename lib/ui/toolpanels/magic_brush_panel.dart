import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class BrushType {
  final String id, name, symbol;
  const BrushType(this.id, this.name, this.symbol);
}

class MagicBrushProvider {
  static const brushes = [
    BrushType('1', 'Sparkles', '✨'),
    BrushType('2', 'Hearts', '❤️'),
    BrushType('3', 'Gold Stars', '⭐'),
    BrushType('4', 'Confetti', '🎉'),
    BrushType('5', 'Fire', '🔥'),
  ];
}

class MagicBrushToolPanel extends StatelessWidget {
  final String selectedBrushSymbol;
  final ValueChanged<String> onBrushSelected;
  final ValueChanged<String> onAddBrushStamp;
  final VoidCallback onClearBrushes;

  const MagicBrushToolPanel({
    super.key,
    required this.selectedBrushSymbol,
    required this.onBrushSelected,
    required this.onAddBrushStamp,
    required this.onClearBrushes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_fix_high, color: primaryPink, size: 18),
                SizedBox(width: 6),
                Text(
                  'Magic Sparkle Brush',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: onClearBrushes,
              icon: const Icon(Icons.delete, color: Colors.red, size: 16),
              label: const Text(
                'Clear Brush',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MagicBrushProvider.brushes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final brush = MagicBrushProvider.brushes[i];
              final isSelected = brush.symbol == selectedBrushSymbol;
              return GestureDetector(
                onTap: () {
                  onBrushSelected(brush.symbol);
                  onAddBrushStamp(brush.symbol);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
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
                      Text(brush.symbol, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        brush.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
