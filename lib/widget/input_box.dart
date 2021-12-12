import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final String? initValue;
  final bool obscureText;
  final double height;
  final TextEditingController? controller;

  const InputBox({
    Key? key,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    this.initValue,
    this.obscureText = false,
    this.height = 35,
    this.controller,
  }) : super(key: key);

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Color.fromRGBO(224, 224, 224, 1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(210, 210, 210, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(242, 242, 242, 1),
            offset: Offset(0, 2),
            spreadRadius: 0.0,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, widget.height / 5),
        child: TextFormField(
          style: TextStyle(
            fontFamily: "NanumSR",
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: Colors.grey.shade800,
          ),
          controller: widget.controller,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          initialValue: widget.initValue,
          obscureText: widget.obscureText,
          onTap: widget.onTap,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
