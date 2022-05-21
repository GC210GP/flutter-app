import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/material.dart';

class DDTextField extends StatefulWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final String? labelText;
  final bool isMultiline;
  final bool obscureText;
  final EdgeInsetsGeometry padding;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final BorderSide? border;
  final BorderSide? borderFocus;
  final double elevation;
  final Color? backgroundColor;
  final bool autofocus;
  final EdgeInsetsGeometry? margin;
  final TextInputType? keyboardType;
  final String? hintText;
  final double? fontSize;
  // final RegExp? validator;

  const DDTextField({
    Key? key,
    this.height = 50.0,
    this.width,
    this.labelText,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.focusNode,
    this.borderRadius,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.margin,
    this.border,
    this.borderFocus,
    this.elevation = 0.05,
    this.backgroundColor,
    this.padding = const EdgeInsets.fromLTRB(15, 21, 15, 0),
    this.isMultiline = false,
    this.obscureText = false,
    this.controller,
    // this.validator,
    this.fontSize,
    this.hintText,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<DDTextField> createState() => _DDTextFieldState();
}

class _DDTextFieldState extends State<DDTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    } else {
      _focusNode = widget.focusNode!;
    }

    _focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            widget.borderRadius ?? GlobalVariables.radius),
        boxShadow: [
          if (_focusNode.hasFocus)
            BoxShadow(
              blurRadius: 7.0,
              spreadRadius: 1.0,
              color: Colors.black.withOpacity(widget.elevation),
              offset: const Offset(0, 1.5),
            ),
        ],
      ),
      child: TextFormField(
        autofocus: widget.autofocus,
        onTap: widget.onTap,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        focusNode: _focusNode,
        cursorColor: DDColor.primary,
        initialValue: widget.labelText,
        // validator: (value) => widget.validator != null
        //     ? widget.validator!.hasMatch(value ?? "")
        //         ? "OO"
        //         : "XX"
        //     : null,
        style: TextStyle(
          color: DDColor.fontColor,
          fontSize: widget.fontSize ?? DDFontSize.h4,
          fontWeight: DDFontWeight.bold,
        ),
        textInputAction: widget.isMultiline ? TextInputAction.newline : null,
        keyboardType:
            widget.isMultiline ? TextInputType.multiline : widget.keyboardType,
        maxLines: widget.isMultiline ? 20 : 1,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: DDColor.disabled,
            fontSize: widget.fontSize ?? DDFontSize.h4,
            fontWeight: DDFontWeight.bold,
          ),
          contentPadding: widget.padding,
          filled: true,
          fillColor: widget.backgroundColor ?? DDColor.widgetBackgroud,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius ?? GlobalVariables.radius),
            ),
            borderSide: widget.borderFocus ??
                const BorderSide(
                  width: .0,
                  color: DDColor.white,
                ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius ?? GlobalVariables.radius),
            ),
            borderSide: widget.border ??
                const BorderSide(
                  width: 0,
                  color: DDColor.white,
                ),
          ),
        ),
      ),
    );
  }
}
