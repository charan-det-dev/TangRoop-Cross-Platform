import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 4x5 color matrix utilities (equivalent to Android ColorMatrix).
class CM {
  static const identity = <double>[
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0,
  ];

  static List<double> multiply(List<double> a, List<double> b) {
    final out = List<double>.filled(20, 0);
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 5; j++) {
        var sum = 0.0;
        for (var k = 0; k < 4; k++) {
          sum += a[i * 5 + k] * b[k * 5 + j];
        }
        if (j == 4) sum += a[i * 5 + 4];
        out[i * 5 + j] = sum;
      }
    }
    return out;
  }

  static List<double> saturation(double s) {
    final inv = 1 - s;
    final lr = 0.213 * inv, lg = 0.715 * inv, lb = 0.072 * inv;
    return [
      lr + s, lg, lb, 0, 0, //
      lr, lg + s, lb, 0, 0, //
      lr, lg, lb + s, 0, 0, //
      0, 0, 0, 1, 0,
    ];
  }

  static List<double> blend(List<double> filter, double intensity) {
    if (intensity >= 0.99) return filter;
    return [
      for (var i = 0; i < 20; i++) identity[i] * (1 - intensity) + filter[i] * intensity,
    ];
  }

  /// Compose full adjustment pipeline: filter -> saturation -> temp/tint -> contrast -> brightness.
  static List<double> buildEditorMatrix({
    required List<double> filterMatrix,
    required double saturationValue,
    required double temperature,
    required double tint,
    required double contrast,
    required double brightness,
  }) {
    var m = blend(filterMatrix, 1.0);
    m = multiply(m, saturation(saturationValue));
    m = multiply(m, [
      1 + temperature, 0, 0, 0, 0, //
      0, 1 + tint, 0, 0, 0, //
      0, 0, 1 - temperature, 0, 0, //
      0, 0, 0, 1, 0,
    ]);
    final translate = (-0.5 * contrast + 0.5) * 255;
    m = multiply(m, [
      contrast, 0, 0, 0, translate, //
      0, contrast, 0, 0, translate, //
      0, 0, contrast, 0, translate, //
      0, 0, 0, 1, 0,
    ]);
    final offset = brightness * 255;
    m = multiply(m, [
      1, 0, 0, 0, offset, //
      0, 1, 0, 0, offset, //
      0, 0, 1, 0, offset, //
      0, 0, 0, 1, 0,
    ]);
    return m;
  }

  static ColorFilter toColorFilter(List<double> m) =>
      ColorFilter.matrix(m.map((v) => v.toDouble()).toList());
}

/// Vector math helpers for math filters (vignette etc.).
Offset radialOffset(double radius, double angle) =>
    Offset(radius * math.cos(angle), radius * math.sin(angle));
