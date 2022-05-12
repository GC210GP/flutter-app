import 'package:app/util/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

class DDToast {
  static void showToast(String msg) {
    _vibration();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black.withOpacity(0.5),
      textColor: Colors.white,
      fontSize: DDFontSize.h4,
    );
  }

  static Future<void> _vibration() async {
    await Vibration.vibrate(
        pattern: [0, 40, 15, 40, 120, 70], intensities: [220, 150, 255]);

    // await Future.delayed(const Duration(milliseconds: 1000));
    // await Vibration.vibrate(duration: 80);
    // await Future.delayed(const Duration(milliseconds: 200));
    // await Vibration.vibrate(duration: 200);
  }
}
