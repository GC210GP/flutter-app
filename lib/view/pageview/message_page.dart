import 'package:flutter/material.dart';

class MessagePageView extends StatefulWidget {
  const MessagePageView({Key? key}) : super(key: key);

  @override
  _MessagePageViewState createState() => _MessagePageViewState();
}

class _MessagePageViewState extends State<MessagePageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "메시지 준비중입니다",
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
