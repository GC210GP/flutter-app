import 'package:flutter/material.dart';

class SettingPageView extends StatefulWidget {
  const SettingPageView({Key? key}) : super(key: key);

  @override
  _SettingPageViewState createState() => _SettingPageViewState();
}

class _SettingPageViewState extends State<SettingPageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "준비중입니다",
          style: TextStyle(
            fontFamily: "NanumSR",
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
