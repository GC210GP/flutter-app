import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/material.dart';

class DDDropdownButton extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final String? labelText;
  final Function(String?)? onChanged;
  final List<String> items;
  final Widget? disabledHint;

  const DDDropdownButton({
    Key? key,
    this.margin,
    this.height = 50,
    this.width,
    this.labelText,
    this.onChanged,
    this.disabledHint,
    this.items = const <String>[],
  }) : super(key: key);

  @override
  State<DDDropdownButton> createState() => _DDDropdownButtonState();
}

class _DDDropdownButtonState extends State<DDDropdownButton> {
  String? _chosenValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
      decoration: BoxDecoration(
        color: DDColor.white,
        borderRadius: BorderRadius.circular(GlobalVariables.radius),
        border: Border.all(
          color: DDColor.white,
          width: 2.0,
        ),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        disabledHint: widget.disabledHint,
        borderRadius: BorderRadius.circular(GlobalVariables.radius),
        focusColor: Colors.white,
        value: _chosenValue,
        iconEnabledColor: Colors.black,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: DDColor.disabled,
          size: 30,
        ),
        items: widget.items
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    color: DDColor.fontColor,
                    fontSize: DDFontSize.h4,
                    fontWeight: DDFontWeight.extraBold,
                  ),
                ),
              ),
            )
            .toList(),
        hint: Text(
          widget.labelText ?? "",
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            color: DDColor.fontColor,
            fontSize: DDFontSize.h4,
            fontWeight: DDFontWeight.extraBold,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _chosenValue = value!;
          });
          if (widget.onChanged != null) widget.onChanged!(value);
        },
      ),
    );
  }
}
