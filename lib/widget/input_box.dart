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



// class InputBox extends StatefulWidget {
//   final void Function(String)? onChanged;
//   final void Function()? onEditingComplete;
//   final void Function(String)? onFieldSubmitted;
//   final void Function()? onTap;
//   final String? initValue;
//   final bool obscureText;
//   final double height;
//   final TextEditingController? controller;

//   const InputBox({
//     Key? key,
//     this.onChanged,
//     this.onEditingComplete,
//     this.onFieldSubmitted,
//     this.onTap,
//     this.initValue,
//     this.obscureText = false,
//     this.height = 35,
//     this.controller,
//   }) : super(key: key);

//   @override
//   _InputBoxState createState() => _InputBoxState();
// }

// class _InputBoxState extends State<InputBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         border: Border.all(color: Color.fromRGBO(224, 224, 224, 1), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromRGBO(210, 210, 210, 1),
//           ),
//           BoxShadow(
//             color: Color.fromRGBO(242, 242, 242, 1),
//             offset: Offset(0, 2),
//             spreadRadius: 0.0,
//             blurRadius: 5.0,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(15, 0, 15, widget.height / 5),
//         child: TextFormField(
//           style: TextStyle(
//             fontFamily: "NanumSR",
//             fontWeight: FontWeight.w900,
//             fontSize: 15,
//             color: Colors.grey.shade800,
//           ),
//           controller: widget.controller,
//           onChanged: widget.onChanged,
//           onEditingComplete: widget.onEditingComplete,
//           onFieldSubmitted: widget.onFieldSubmitted,
//           initialValue: widget.initValue,
//           obscureText: widget.obscureText,
//           onTap: widget.onTap,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
