import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TextPreset {
  final String id, title, text;
  final Color defaultColor;
  final double defaultSize;
  const TextPreset(this.id, this.title, this.text, this.defaultColor,
      [this.defaultSize = 36]);
}

class TextPresetProvider {
  static const presets = [
    TextPreset('c1', 'TheCaveManRelaxes',
        'TheCaveManRelaxes\nหลิวมนุษย์ถ้ำ | คิดถึงน่าน\nขอให้น่านกลับสู่ความงามอีกครั้งในเร็ววัน', Colors.white, 28),
    TextPreset('c2', 'Cinematic Nan', 'THAI ATMOSPHERE\nบรรยากาศแห่งความทรงจำ', Colors.white, 30),
    TextPreset('1', 'My Plan', 'My plan for today ✨', primaryPink, 38),
    TextPreset('2', 'Capable', 'You are capable of amazing things', primaryViolet, 34),
    TextPreset('3', 'Reading', 'READING TIME 📖', Color(0xFF3F51B5), 36),
    TextPreset('4', 'Cute', 'SO CUTEO 💜', Color(0xFF814CC2), 40),
    TextPreset('5', 'Looks Good', 'LOOKS SO GOOD', accentGold, 38),
    TextPreset('6', 'Happy', 'HAPPY DAY ☀️', Color(0xFFFF9800), 38),
    TextPreset('7', 'Aesthetic', 'a e s t h e t i c', Colors.white, 32),
  ];
}
