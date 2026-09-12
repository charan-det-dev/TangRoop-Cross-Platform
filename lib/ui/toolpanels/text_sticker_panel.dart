import 'package:flutter/material.dart';
import '../../core/data/text_preset.dart';
import '../../core/theme/app_colors.dart';
import 'shared_widgets.dart';

class TextToolPanel extends StatelessWidget {
  final String text;
  final ValueChanged<String> onTextChange;
  final double textSize;
  final ValueChanged<double> onTextSizeChange;
  final Color selectedColor;
  final ValueChanged<Color> onColorChange;
  final ValueChanged<TextPreset> onSelectTextPreset;

  const TextToolPanel({
    super.key,
    required this.text,
    required this.onTextChange,
    required this.textSize,
    required this.onTextSizeChange,
    required this.selectedColor,
    required this.onColorChange,
    required this.onSelectTextPreset,
  });

  static const colors = [
    Colors.white, Colors.black, Colors.red, Colors.yellow, Colors.green,
    Colors.blue, Colors.cyan, Colors.magenta, primaryPink,
    Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF3F51B5), Color(0xFF00BCD4),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Text Presets',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: TextPresetProvider.presets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final preset = TextPresetProvider.presets[i];
                return GestureDetector(
                  onTap: () => onSelectTextPreset(preset),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(preset.title,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: preset.defaultColor)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController(text: text)
              ..selection = TextSelection.collapsed(offset: text.length),
            onChanged: onTextChange,
            decoration: const InputDecoration(
              hintText: 'Enter text here...',
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 10),
          AdjustmentSlider(
              label: 'Text Size',
              value: textSize,
              min: 10, max: 100, defaultValue: 32,
              onValueChange: onTextSizeChange),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final color = colors[i];
                final isSelected = selectedColor == color;
                return GestureDetector(
                  onTap: () => onColorChange(color),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.withValues(alpha: 0.4),
                          width: isSelected ? 2 : 1),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StickerToolPanel extends StatelessWidget {
  final ValueChanged<String> onStickerSelected;
  const StickerToolPanel({super.key, required this.onStickerSelected});

  static const stickers = [
    '❤️', '🔥', '✨', '⭐', '🎉', '😎', '🌈', '📸', '🎨',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select a Sticker',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stickers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => onStickerSelected(stickers[i]),
              child: Text(stickers[i],
                  style: const TextStyle(fontSize: 40)),
            ),
          ),
        ),
      ],
    );
  }
}

class CropToolPanel extends StatelessWidget {
  final void Function(bool fixRatio, int x, int y) onCropPresetSelected;
  const CropToolPanel({super.key, required this.onCropPresetSelected});

  static const presets = [
    ('Free', Icons.crop_free, false, 1, 1),
    ('1:1', Icons.crop_square, true, 1, 1),
    ('9:16', Icons.crop_portrait, true, 9, 16),
    ('4:5', Icons.crop_portrait, true, 4, 5),
    ('16:9', Icons.crop_16_9, true, 16, 9),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Crop & Rotate Aspect Ratios',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text('Tap to open cropper',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: presets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (label, icon, fixRatio, rx, ry) = presets[i];
              return GestureDetector(
                onTap: () => onCropPresetSelected(fixRatio, rx, ry),
                child: Container(
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Icon(icon, color: primaryPink, size: 18),
                    const SizedBox(width: 6),
                    Text(label,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
