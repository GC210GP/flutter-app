import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/material.dart';

// 회원가입 완료
class SignPage7 extends StatefulWidget {
  const SignPage7({Key? key}) : super(key: key);

  @override
  State<SignPage7> createState() => _SignPage7State();
}

class _SignPage7State extends State<SignPage7> {
  double pageOpacity = 0.0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      pageOpacity = 1.0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Processing(),
        ],
      ),
    );
  }
}

class Processing extends StatelessWidget {
  const Processing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              strokeWidth: 15.0,
              color: DDColor.primary.shade600,
              backgroundColor: DDColor.disabled,
            ),
          ),
        ),
        const SizedBox(height: 50.0),
        Text(
          "조금만 더 기다려주세요...",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h2,
            color: DDColor.fontColor,
          ),
        ),
      ],
    );
  }
}
