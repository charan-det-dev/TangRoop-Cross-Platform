import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../core/engine/color_matrix.dart';

enum LayerType { text, sticker }

class LayerData {
  final String id;
  final LayerType type;
  String content;
  Color? color;
  double x;
  double y;
  double scale;
  double rotation;

  LayerData({
    String? id,
    required this.type,
    required this.content,
    this.color,
    this.x = 0,
    this.y = 0,
    this.scale = 1.0,
    this.rotation = 0.0,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  LayerData copyWith({
    String? content,
    Color? color,
    double? x,
    double? y,
    double? scale,
    double? rotation,
  }) {
    return LayerData(
      id: id,
      type: type,
      content: content ?? this.content,
      color: color ?? this.color,
      x: x ?? this.x,
      y: y ?? this.y,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }
}

class EditorSnapshot {
  final double brightness, contrast, saturation, temperature, tint;
  final String selectedFilterName;
  final double filterIntensity;
  final double smoothIntensity, skinToneIntensity;
  final double eyeEnlargeIntensity, faceSlimIntensity;
  final int detectedFaceCount;
  final String cutoutBgType;
  final Color cutoutSolidColor;
  final String vfxName;
  final double vfxIntensity;
  final double collageSpacing, collageCornerRadius;
  final List<LayerData> layers;

  EditorSnapshot({
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.temperature,
    required this.tint,
    required this.selectedFilterName,
    required this.filterIntensity,
    required this.smoothIntensity,
    required this.skinToneIntensity,
    required this.eyeEnlargeIntensity,
    required this.faceSlimIntensity,
    required this.detectedFaceCount,
    required this.cutoutBgType,
    required this.cutoutSolidColor,
    required this.vfxName,
    required this.vfxIntensity,
    required this.collageSpacing,
    required this.collageCornerRadius,
    required this.layers,
  });
}

class EditorState extends ChangeNotifier {
  XFile? originalImage;

  double brightness = 0;
  double contrast = 1;
  double saturation = 1;
  double temperature = 0;
  double tint = 0;

  String selectedFilterName = 'Original';
  double filterIntensity = 1.0;

  double smoothIntensity = 0;
  double skinToneIntensity = 0;
  double eyeEnlargeIntensity = 0;
  double faceSlimIntensity = 0;

  int detectedFaceCount = 0;

  String cutoutBgType = 'None';
  Color cutoutSolidColor = Colors.white;

  String vfxName = 'None';
  double vfxIntensity = 0;

  double collageSpacing = 16;
  double collageCornerRadius = 24;

  List<LayerData> layers = [];
  String? selectedLayerId;

  // History for undo/redo
  final List<EditorSnapshot> _undoStack = [];
  final List<EditorSnapshot> _redoStack = [];

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  List<double> get colorMatrix {
    // Basic filter mapping (for demo purposes we use identity if 'Original')
    // In real usage, you would fetch from FilterProvider based on selectedFilterName
    final filterMatrix = CM.identity;
    return CM.buildEditorMatrix(
      filterMatrix: filterMatrix,
      saturationValue: saturation,
      temperature: temperature,
      tint: tint,
      contrast: contrast,
      brightness: brightness,
    );
  }

  void _saveSnapshot() {
    _undoStack.add(_createSnapshot());
    _redoStack.clear();
    // optional: limit stack size
  }

  EditorSnapshot _createSnapshot() {
    return EditorSnapshot(
      brightness: brightness,
      contrast: contrast,
      saturation: saturation,
      temperature: temperature,
      tint: tint,
      selectedFilterName: selectedFilterName,
      filterIntensity: filterIntensity,
      smoothIntensity: smoothIntensity,
      skinToneIntensity: skinToneIntensity,
      eyeEnlargeIntensity: eyeEnlargeIntensity,
      faceSlimIntensity: faceSlimIntensity,
      detectedFaceCount: detectedFaceCount,
      cutoutBgType: cutoutBgType,
      cutoutSolidColor: cutoutSolidColor,
      vfxName: vfxName,
      vfxIntensity: vfxIntensity,
      collageSpacing: collageSpacing,
      collageCornerRadius: collageCornerRadius,
      layers: layers.map((l) => l.copyWith()).toList(),
    );
  }

  void _restoreSnapshot(EditorSnapshot snap) {
    brightness = snap.brightness;
    contrast = snap.contrast;
    saturation = snap.saturation;
    temperature = snap.temperature;
    tint = snap.tint;
    selectedFilterName = snap.selectedFilterName;
    filterIntensity = snap.filterIntensity;
    smoothIntensity = snap.smoothIntensity;
    skinToneIntensity = snap.skinToneIntensity;
    eyeEnlargeIntensity = snap.eyeEnlargeIntensity;
    faceSlimIntensity = snap.faceSlimIntensity;
    detectedFaceCount = snap.detectedFaceCount;
    cutoutBgType = snap.cutoutBgType;
    cutoutSolidColor = snap.cutoutSolidColor;
    vfxName = snap.vfxName;
    vfxIntensity = snap.vfxIntensity;
    collageSpacing = snap.collageSpacing;
    collageCornerRadius = snap.collageCornerRadius;
    layers = snap.layers.map((l) => l.copyWith()).toList();
    notifyListeners();
  }

  void undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(_createSnapshot());
      final snap = _undoStack.removeLast();
      _restoreSnapshot(snap);
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(_createSnapshot());
      final snap = _redoStack.removeLast();
      _restoreSnapshot(snap);
    }
  }

  void clearSelection() {
    selectedLayerId = null;
    notifyListeners();
  }

  void selectLayer(String id) {
    selectedLayerId = id;
    notifyListeners();
  }

  void updateLayerPosition(String id, double dx, double dy) {
    final idx = layers.indexWhere((l) => l.id == id);
    if (idx != -1) {
      // Create a snapshot before movement? No, too many snapshots. Usually save on move end.
      layers[idx].x += dx;
      layers[idx].y += dy;
      notifyListeners();
    }
  }

  void addTextLayer(String text) {
    _saveSnapshot();
    layers.add(LayerData(
      type: LayerType.text,
      content: text,
      color: Colors.white,
      x: 100,
      y: 100,
      scale: 1.0,
    ));
    selectedLayerId = layers.last.id;
    notifyListeners();
  }

  void addStickerLayer(String emoji) {
    _saveSnapshot();
    layers.add(LayerData(
      type: LayerType.sticker,
      content: emoji,
      x: 100,
      y: 100,
      scale: 1.5,
    ));
    selectedLayerId = layers.last.id;
    notifyListeners();
  }

  // Setters for basic adjustments
  void updateAdjustment({
    double? brightness, double? contrast, double? saturation,
    double? temperature, double? tint,
  }) {
    // Normally you'd debounce _saveSnapshot() here
    if (brightness != null) this.brightness = brightness;
    if (contrast != null) this.contrast = contrast;
    if (saturation != null) this.saturation = saturation;
    if (temperature != null) this.temperature = temperature;
    if (tint != null) this.tint = tint;
    notifyListeners();
  }
}
