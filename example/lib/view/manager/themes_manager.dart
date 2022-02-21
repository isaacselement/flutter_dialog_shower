import 'package:flutter/material.dart';

class ThemesManager {
  static Color getXpButtonColor(String buttonText) {
    if (buttonText.contains('center')) {
      return const Color(0xFF4275FF);
    }
    if (buttonText.contains('left')) {
      return const Color(0xFF8383F0);
    }
    if (buttonText.contains('right')) {
      return const Color(0xFF00BDAC);
    }
    if (buttonText.contains('x/y')) {
      return const Color(0xFF0598FA);
    }
    return const Color(0xFFAD60EC);
  }
}
