import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/cupertino.dart';

class DDButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color? color;
  final Color? fontColor;
  final EdgeInsetsGeometry? margin;

  final double? height;
  final double? width;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Widget? child;

  const DDButton({
    Key? key,
    this.label = "",
    this.onPressed,
    this.color,
    this.child,
    this.fontColor,
    this.margin,
    this.height = 50,
    this.width,
    this.fontWeight,
    this.fontSize,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: CupertinoButton(
        borderRadius:
            BorderRadius.circular(borderRadius ?? GlobalVariables.radius),
        child: child ??
            Text(
              label,
              style: TextStyle(
                fontFamily: DDFontFamily.nanumSR,
                fontWeight: fontWeight ?? DDFontWeight.extraBold,
                fontSize: fontSize ?? DDFontSize.h35,
                color: fontColor ?? DDColor.widgetBackgroud,
              ),
            ),
        color: color ?? DDColor.primary,
        padding: const EdgeInsets.all(0),
        onPressed: onPressed,
      ),
    );
  }
}
