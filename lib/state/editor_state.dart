import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class TextLayer {
  final String id;
  String text;
  Color color;
  double size;
  Offset offset;
  double rotation;
  double scale;
  TextLayer({
    String? id,
    this.text = '',
    this.color = primaryViolet,
    this.size = 32,
    this.offset = Offset.zero,
    this.rotation = 0,
    this.scale = 1,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
}

class StickerLayer {
  final String id;
  String sticker;
  Offset offset;
  double rotation;
  double scale;
  StickerLayer({
    String? id,
    this.sticker = '',
    this.offset = Offset.zero,
    this.rotation = 0,
    this.scale = 1,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
}

@immutable
class EditorState {
  final double brightness, contrast, saturation, temperature, tint;
  final String selectedFilterName;
  final double filterIntensity;
  final double smoothIntensity, skinToneIntensity;
  final double eyeEnlargeIntensity, faceSlimIntensity;
  final int detectedFaceCount;
  final String cutoutBgType; // None | Transparent | Solid | Blur
  final Color cutoutSolidColor;
  final String vfxName; // None | Vignette | Bokeh | Film Grain ...
  final double vfxIntensity;
  final double collageSpacing, collageCornerRadius;
  final List<TextLayer> textLayers;
  final List<StickerLayer> stickerLayers;
  final String? selectedLayerId;

  const EditorState({
    this.brightness = 0,
    this.contrast = 1,
    this.saturation = 1,
    this.temperature = 0,
    this.tint = 0,
    this.selectedFilterName = 'Original',
    this.filterIntensity = 1.0,
    this.smoothIntensity = 0,
    this.skinToneIntensity = 0,
    this.eyeEnlargeIntensity = 0,
    this.faceSlimIntensity = 0,
    this.detectedFaceCount = 0,
    this.cutoutBgType = 'None',
    this.cutoutSolidColor = Colors.white,
    this.vfxName = 'None',
    this.vfxIntensity = 0,
    this.collageSpacing = 16,
    this.collageCornerRadius = 24,
    this.textLayers = const [],
    this.stickerLayers = const [],
    this.selectedLayerId,
  });

  EditorState copyWith({
    double? brightness, double? contrast, double? saturation,
    double? temperature, double? tint, String? selectedFilterName,
    double? filterIntensity, double? smoothIntensity,
    double? skinToneIntensity, double? eyeEnlargeIntensity,
    double? faceSlimIntensity, int? detectedFaceCount,
    String? cutoutBgType, Color? cutoutSolidColor,
    String? vfxName, double? vfxIntensity,
    double? collageSpacing, double? collageCornerRadius,
    List<TextLayer>? textLayers, List<StickerLayer>? stickerLayers,
    String? selectedLayerId, bool clearSelection = false,
  }) {
    return EditorState(
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      temperature: temperature ?? this.temperature,
      tint: tint ?? this.tint,
      selectedFilterName: selectedFilterName ?? this.selectedFilterName,
      filterIntensity: filterIntensity ?? this.filterIntensity,
      smoothIntensity: smoothIntensity ?? this.smoothIntensity,
      skinToneIntensity: skinToneIntensity ?? this.skinToneIntensity,
      eyeEnlargeIntensity: eyeEnlargeIntensity ?? this.eyeEnlargeIntensity,
      faceSlimIntensity: faceSlimIntensity ?? this.faceSlimIntensity,
      detectedFaceCount: detectedFaceCount ?? this.detectedFaceCount,
      cutoutBgType: cutoutBgType ?? this.cutoutBgType,
      cutoutSolidColor: cutoutSolidColor ?? this.cutoutSolidColor,
      vfxName: vfxName ?? this.vfxName,
      vfxIntensity: vfxIntensity ?? this.vfxIntensity,
      collageSpacing: collageSpacing ?? this.collageSpacing,
      collageCornerRadius: collageCornerRadius ?? this.collageCornerRadius,
      textLayers: textLayers ?? this.textLayers,
      stickerLayers: stickerLayers ?? this.stickerLayers,
      selectedLayerId: clearSelection ? null : (selectedLayerId ?? this.selectedLayerId),
    );
  }
}
