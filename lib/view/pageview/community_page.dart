import 'package:flutter/material.dart';

class CommunityPageView extends StatefulWidget {
  const CommunityPageView({Key? key}) : super(key: key);

  @override
  _CommunityPageViewState createState() => _CommunityPageViewState();
}

class _CommunityPageViewState extends State<CommunityPageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "커뮤니티 준비중입니다",
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
