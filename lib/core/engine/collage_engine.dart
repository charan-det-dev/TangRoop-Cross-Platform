import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Collage engine: compose 1-6 images into a grid with spacing + rounded corners.
class CollageEngine {
  static Future<ui.Image> createCollage(
    List<ui.Image> bitmaps, {
    int targetWidth = 1080,
    int targetHeight = 1080,
    double spacing = 16,
    double cornerRadius = 24,
    Color backgroundColor = Colors.white,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
        Paint()..color = backgroundColor);

    final count = math.min(bitmaps.length, 6);
    final rects = <Rect>[];
    final s = spacing;
    final W = targetWidth.toDouble(), H = targetHeight.toDouble();
    switch (count) {
      case 1:
        rects.add(Rect.fromLTRB(s, s, W - s, H - s));
      case 2:
        final halfW = W / 2;
        rects
          ..add(Rect.fromLTRB(s, s, halfW - s / 2, H - s))
          ..add(Rect.fromLTRB(halfW + s / 2, s, W - s, H - s));
      case 3:
        final halfH = H / 2, halfW = W / 2;
        rects
          ..add(Rect.fromLTRB(s, s, W - s, halfH - s / 2))
          ..add(Rect.fromLTRB(s, halfH + s / 2, halfW - s / 2, H - s))
          ..add(Rect.fromLTRB(halfW + s / 2, halfH + s / 2, W - s, H - s));
      case 4:
        final halfW = W / 2, halfH = H / 2;
        rects
          ..add(Rect.fromLTRB(s, s, halfW - s / 2, halfH - s / 2))
          ..add(Rect.fromLTRB(halfW + s / 2, s, W - s, halfH - s / 2))
          ..add(Rect.fromLTRB(s, halfH + s / 2, halfW - s / 2, H - s))
          ..add(Rect.fromLTRB(halfW + s / 2, halfH + s / 2, W - s, H - s));
      default:
        final colW = W / 3, rowH = H / 2;
        for (var i = 0; i < count; i++) {
          final col = i % 3, row = i ~/ 3;
          rects.add(Rect.fromLTRB(
              col * colW + s, row * rowH + s, (col + 1) * colW - s, (row + 1) * rowH - s));
        }
    }
    for (var i = 0; i < rects.length && i < bitmaps.length; i++) {
      final rPath = Path()
        ..addRRect(RRect.fromRectAndRadius(rects[i], Radius.circular(cornerRadius)));
      canvas.save();
      canvas.clipPath(rPath);
      // Cover-fit draw
      final img = bitmaps[i];
      final srcAR = img.width / img.height;
      final dstAR = rects[i].width / rects[i].height;
      double sw = img.width.toDouble(), sh = img.height.toDouble();
      double dx = 0, dy = 0;
      if (srcAR > dstAR) {
        sw = sh * dstAR;
        dx = (img.width - sw) / 2;
      } else {
        sh = sw / dstAR;
        dy = (img.height - sh) / 2;
      }
      canvas.drawImageRect(
          img,
          Rect.fromLTWH(dx, dy, sw, sh),
          rects[i],
          Paint()..filterQuality = FilterQuality.high);
      canvas.restore();
    }
    final picture = recorder.endRecording();
    return picture.toImage(targetWidth, targetHeight);
  }
}
