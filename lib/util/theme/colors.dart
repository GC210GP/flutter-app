import 'package:flutter/material.dart';

class DDColor {
  static final MaterialColor primary = MaterialColor(
    0xFFEF5350,
    <int, Color>{
      400: Color(Colors.red.shade800.value),
      500: const Color(0xFFEF5350),
      600: Color(Colors.red.shade300.value),
    },
  );

  static final Color disabled = Colors.grey.shade300;

  static const Color widgetBackgroud = Colors.white;
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static final Color grey = Colors.grey.shade400;

  static final Color fontColor = Colors.grey.shade900;

  // 색상 조율
  // static const Color white = Colors.grey.shade900;
  // static const Color white = Colors.grey.shade800;
  // static const Color white = Colors.grey.shade100;
  // static const Color white = Colors.grey.shade200;
  // static const Color white = Colors.grey.shade500;

  // 색 바꾸기
  // static const Color white = Colors.grey.shade400;
  // static const Color white = Colors.grey.shade600;
}
