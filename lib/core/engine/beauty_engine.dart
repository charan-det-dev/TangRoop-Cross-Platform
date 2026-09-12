import 'dart:typed_data';
import 'dart:ui' as ui;

/// Pixel-level beauty engine (cross-platform, pure Dart + dart:ui).
class BeautyEngine {
  /// Apply beauty ops on raw RGBA pixels, return edited [ui.Image].
  static Future<ui.Image> applyBeauty(
    ui.Image source, {
    double smoothIntensity = 0,
    double skinToneIntensity = 0,
  }) async {
    final src = await source.toByteData(format: ui.ImageByteFormat.rawRgba);
    final pixels = Uint8List.fromList(src!.buffer.asUint8List());
    final w = source.width, h = source.height;

    if (smoothIntensity > 0.01) {
      final blurred = _boxBlur(pixels, w, h, 3);
      final alpha = (smoothIntensity.clamp(0, 1) * 160).round();
      for (var i = 0; i < pixels.length; i += 4) {
        final a = alpha / 255;
        for (var c = 0; c < 3; c++) {
          pixels[i + c] =
              (pixels[i + c] * (1 - a) + blurred[i + c] * a).round().clamp(0, 255);
        }
      }
    }
    if (skinToneIntensity > 0.01) {
      _skinTone(pixels, skinToneIntensity);
    }

    final buffer = await ui.ImmutableBuffer.fromUint8List(pixels);
    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: w,
      height: h,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Simple 3x3 box blur.
  static Uint8List _boxBlur(Uint8List src, int w, int h, int radius) {
    final out = Uint8List(src.length);
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        var r = 0, g = 0, b = 0, n = 0;
        for (var dy = -radius; dy <= radius; dy += radius) {
          for (var dx = -radius; dx <= radius; dx += radius) {
            final px = (x + dx).clamp(0, w - 1);
            final py = (y + dy).clamp(0, h - 1);
            final idx = (py * w + px) * 4;
            r += src[idx];
            g += src[idx + 1];
            b += src[idx + 2];
            n++;
          }
        }
        final idx = (y * w + x) * 4;
        out[idx] = r ~/ n;
        out[idx + 1] = g ~/ n;
        out[idx + 2] = b ~/ n;
        out[idx + 3] = src[idx + 3];
      }
    }
    return out;
  }

  static void _skinTone(Uint8List pixels, double tone) {
    final brightness = tone * 35;
    final contrast = 1 + tone * 0.08;
    for (var i = 0; i < pixels.length; i += 4) {
      pixels[i] = (pixels[i] * contrast + brightness).round().clamp(0, 255);
      pixels[i + 1] =
          (pixels[i + 1] * contrast + brightness * 0.95).round().clamp(0, 255);
      pixels[i + 2] =
          (pixels[i + 2] * contrast + brightness * 0.9).round().clamp(0, 255);
    }
  }
}
