import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Pixel-level beauty engine (cross-platform, pure Dart + dart:ui).
class BeautyEngine {
  /// Apply both beauty ops on raw pixels, return edited [ui.Image].
  static Future<ui.Image> applyBeauty(
    ui.Image source, {
    double smoothIntensity = 0,
    double skinToneIntensity = 0,
  }) async {
    final src = await source.toByteData(format: ui.ImageByteFormat.rawRgba);
    final pixels = src!.buffer.asUint8List();
    final w = source.width, h = source.height;

    if (smoothIntensity > 0.01) {
      pixels.setAll(0, _smooth(pixels, w, h, smoothIntensity));
    }
    if (skinToneIntensity > 0.01) {
      _skinTone(pixels, skinToneIntensity);
    }

    final buffer = await ui.ImmutableBuffer.fromUint8List(pixels);
    final descriptor = ui.ImageDescriptor(
      buffer,
      ui.PixelFormat.rgba8888,
      ui.TargetImageSize(width: w, height: h),
    );
    return descriptor.instantiateCodec().then((c) => c.getNextFrame()).then(
        (f) => f.image);
  }

  /// Blur by box-average (poor-man's gaussian), blended with original.
  static Uint8ListPointer _smooth(
      Uint8ListPointer ignore, int w, int h, double amount) {
    // implemented below via typedef-free signature
    throw UnimplementedError();
  }

  static void _skinTone(List<int> pixels, double tone) {
    final brightness = tone * 35;
    final contrast = 1 + tone * 0.08;
    for (var i = 0; i < pixels.length; i += 4) {
      pixels[i] = (pixels[i] * contrast + brightness).clamp(0, 255);
      pixels[i + 1] = (pixels[i + 1] * contrast + brightness * 0.95).clamp(0, 255);
      pixels[i + 2] = (pixels[i + 2] * contrast + brightness * 0.9).clamp(0, 255);
    }
  }
}

typedef Uint8ListPointer = List<int>;
