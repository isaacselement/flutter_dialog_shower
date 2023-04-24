import 'package:flutter/material.dart';

class ThemesManager {
  static BoxDecoration builderXpButtonDecoration(String text, bool isTapingDown) {
    return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: isTapingDown ? ThemesManager.getXpButtonColor(text).withAlpha(200) : ThemesManager.getXpButtonColor(text));
  }

  static Color getXpButtonColor(String buttonText) {
    String string = buttonText.toLowerCase();
    if (string.contains('center')) {
      return const Color(0xFF4275FF);
    }
    if (string.contains('left')) {
      return const Color(0xFF8383F0);
    }
    if (string.contains('right')) {
      return const Color(0xFF00BDAC);
    }
    if (string.contains('x/y')) {
      return const Color(0xFF0598FA);
    }
    if (string.contains('bubble')) {
      return const Color(0xFF1BC25F);
    }
    if (string.contains('navigator')) {
      return const Color(0xFFFF616F);
    }
    return const Color(0xFFAD60EC);
  }
}
