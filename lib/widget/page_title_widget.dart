import 'package:flutter/material.dart';

class PageTitleWidget extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry margin;

  const PageTitleWidget({
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
          fontFamily: "NanumSR",
          fontWeight: FontWeight.w900,
          fontSize: 30,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}
