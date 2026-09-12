import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'shared_widgets.dart';

class BeautyToolPanel extends StatelessWidget {
  final double smooth, skinTone, eyeEnlarge, faceSlim;
  final int detectedFaceCount;
  final ValueChanged<double> onSmoothChange, onSkinToneChange;
  final ValueChanged<double> onEyeEnlargeChange, onFaceSlimChange;
  final VoidCallback onAutoBeauty;

  const BeautyToolPanel({
    super.key,
    required this.smooth,
    required this.skinTone,
    required this.eyeEnlarge,
    required this.faceSlim,
    required this.detectedFaceCount,
    required this.onSmoothChange,
    required this.onSkinToneChange,
    required this.onEyeEnlargeChange,
    required this.onFaceSlimChange,
    required this.onAutoBeauty,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.face_retouching_natural,
                    color: primaryPink, size: 18),
                const SizedBox(width: 6),
                Text(
                  detectedFaceCount > 0
                      ? '$detectedFaceCount Face Detected'
                      : 'Face Retouching',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ]),
              // Auto Retouch gradient pill
              GestureDetector(
                onTap: onAutoBeauty,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: primaryGradientColors),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Auto Retouch',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
            ],
          ),
          AdjustmentSlider(
              label: 'Smooth Skin (ผิวเนียน)',
              value: smooth,
              onValueChange: onSmoothChange),
          AdjustmentSlider(
              label: 'Skin Brightness / Tone (กระจ่างใส)',
              value: skinTone,
              onValueChange: onSkinToneChange),
          AdjustmentSlider(
              label: 'Eye Enlarge (ตาโต)',
              value: eyeEnlarge,
              onValueChange: onEyeEnlargeChange),
          AdjustmentSlider(
              label: 'Face Slimming (หน้าเรียว)',
              value: faceSlim,
              onValueChange: onFaceSlimChange),
        ],
      ),
    );
  }
}
