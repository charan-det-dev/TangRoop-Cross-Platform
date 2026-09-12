import 'package:flutter/material.dart';
import 'editor_state.dart';

class EditorViewModel extends ChangeNotifier {
  EditorState _state = const EditorState();
  EditorState get state => _state;

  final List<EditorState> _undoStack = [];
  final List<EditorState> _redoStack = [];
  bool _updatingFromHistory = false;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void updateState(EditorState newState, {bool saveToHistory = true}) {
    if (saveToHistory && !_updatingFromHistory) {
      _undoStack.add(_state);
      _redoStack.clear();
    }
    _state = newState;
    notifyListeners();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _updatingFromHistory = true;
    _redoStack.add(_state);
    _state = _undoStack.removeLast();
    _updatingFromHistory = false;
    notifyListeners();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _updatingFromHistory = true;
    _undoStack.add(_state);
    _state = _redoStack.removeLast();
    _updatingFromHistory = false;
    notifyListeners();
  }

  void _apply(EditorState Function(EditorState) f, {bool saveToHistory = true}) =>
      updateState(f(_state), saveToHistory: saveToHistory);

  // Layers
  void addTextLayer() {
    final newLayer = TextLayer(text: 'New Text');
    _apply((s) => s.copyWith(
        textLayers: [...s.textLayers, newLayer], selectedLayerId: newLayer.id));
  }

  void addStickerLayer(String sticker) {
    final newLayer = StickerLayer(sticker: sticker);
    _apply((s) => s.copyWith(
        stickerLayers: [...s.stickerLayers, newLayer],
        selectedLayerId: newLayer.id));
  }

  void removeSelectedLayer() {
    final id = _state.selectedLayerId;
    if (id == null) return;
    _apply((s) => s.copyWith(
        textLayers: s.textLayers.where((l) => l.id != id).toList(),
        stickerLayers: s.stickerLayers.where((l) => l.id != id).toList(),
        clearSelection: true));
  }

  void selectLayer(String? id) {
    _state = _state.copyWith(selectedLayerId: id, clearSelection: id == null);
    notifyListeners();
  }

  void updateSelectedTextLayer(TextLayer Function(TextLayer) update) {
    final id = _state.selectedLayerId;
    if (id == null) return;
    _apply((s) => s.copyWith(textLayers: [
          for (final l in s.textLayers) if (l.id == id) update(l) else l,
        ]));
  }

  void updateSelectedStickerLayer(StickerLayer Function(StickerLayer) update) {
    final id = _state.selectedLayerId;
    if (id == null) return;
    _apply((s) => s.copyWith(stickerLayers: [
          for (final l in s.stickerLayers) if (l.id == id) update(l) else l,
        ]));
  }

  // Adjust setters
  void setBrightness(double v) => _apply((s) => s.copyWith(brightness: v));
  void setContrast(double v) => _apply((s) => s.copyWith(contrast: v));
  void setSaturation(double v) => _apply((s) => s.copyWith(saturation: v));
  void setTemperature(double v) => _apply((s) => s.copyWith(temperature: v));
  void setTint(double v) => _apply((s) => s.copyWith(tint: v));
  void setFilter(String name, {double intensity = 1.0}) =>
      _apply((s) => s.copyWith(selectedFilterName: name, filterIntensity: intensity));
  void setFilterIntensity(double v) => _apply((s) => s.copyWith(filterIntensity: v));

  // Beauty setters
  void setSmoothIntensity(double v) => _apply((s) => s.copyWith(smoothIntensity: v));
  void setSkinToneIntensity(double v) => _apply((s) => s.copyWith(skinToneIntensity: v));
  void setEyeEnlargeIntensity(double v) =>
      _apply((s) => s.copyWith(eyeEnlargeIntensity: v));
  void setFaceSlimIntensity(double v) => _apply((s) => s.copyWith(faceSlimIntensity: v));
  void setDetectedFaceCount(int count) =>
      updateState(_state.copyWith(detectedFaceCount: count), saveToHistory: false);

  void applyAutoBeauty() => _apply((s) => s.copyWith(
      smoothIntensity: 0.5,
      skinToneIntensity: 0.3,
      eyeEnlargeIntensity: 0.2,
      faceSlimIntensity: 0.2));

  // AI Cutout & VFX
  void setCutoutBgType(String type) => _apply((s) => s.copyWith(cutoutBgType: type));
  void setCutoutSolidColor(Color color) =>
      _apply((s) => s.copyWith(cutoutSolidColor: color));
  void setVfx(String name, {double intensity = 0.5}) =>
      _apply((s) => s.copyWith(vfxName: name, vfxIntensity: intensity));
  void setVfxIntensity(double v) => _apply((s) => s.copyWith(vfxIntensity: v));

  // Collage
  void setCollageSpacing(double v) => _apply((s) => s.copyWith(collageSpacing: v));
  void setCollageCornerRadius(double v) =>
      _apply((s) => s.copyWith(collageCornerRadius: v));
}
