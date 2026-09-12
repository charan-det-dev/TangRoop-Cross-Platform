import 'package:flutter/material.dart';

class AppTheme {
  static const fontFamily = 'IbmPlexSansThai';

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF814CC2)),
      scaffoldBackgroundColor: const Color(0xFFFAFAFD),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: fontFamily),
      colorScheme: base.colorScheme.copyWith(surface: Colors.white),
      sliderTheme: base.sliderTheme.copyWith(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
    );
  }
}
