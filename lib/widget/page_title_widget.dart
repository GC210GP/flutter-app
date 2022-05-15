import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/material.dart';

class DDPageTitleWidget extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry margin;

  const DDPageTitleWidget({
    Key? key,
    required this.title,
    this.margin = const EdgeInsets.only(bottom: 20.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: DDFontFamily.nanumSR,
          fontWeight: DDFontWeight.extraBold,
          fontSize: DDFontSize.h15,
          color: DDColor.fontColor,
        ),
      ),
    );
  }
}
