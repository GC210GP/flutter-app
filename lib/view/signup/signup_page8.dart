import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 회원가입 완료
class SignPage8 extends StatefulWidget {
  final VoidCallback? onPressed;
  final Status status;

  const SignPage8({
    Key? key,
    this.onPressed,
    required this.status,
  }) : super(key: key);

  @override
  State<SignPage8> createState() => _SignPage8State();
}

class _SignPage8State extends State<SignPage8> {
  late Status status;

  double pageOpacity = 0.0;

  @override
  void initState() {
    status = widget.status;
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
        children: [
          if (status == Status.success)
            Column(
              children: [
                const SizedBox(height: 50.0),
                const Complete(),
                const SizedBox(height: 50.0),
                DDButton(
                  width: 120,
                  label: "로그인",
                  onPressed: widget.onPressed,
                ),
              ],
            ),
          if (status == Status.fail)
            Column(
              children: [
                const SizedBox(height: 50.0),
                const Fail(),
                const SizedBox(height: 50.0),
                DDButton(
                  width: 120,
                  label: "돌아가기",
                  onPressed: widget.onPressed,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

enum Status {
  processing,
  success,
  fail,
}

class Complete extends StatelessWidget {
  const Complete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          padding: const EdgeInsets.only(top: 7.0),
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 3.0),
              ),
            ],
          ),
          child: const Icon(
            CupertinoIcons.checkmark_alt,
            color: DDColor.white,
            size: 60.0,
          ),
        ),
        const SizedBox(height: 25.0),
        Text(
          "회원가입이 완료되었어요!",
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

class Fail extends StatelessWidget {
  const Fail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          padding: const EdgeInsets.only(top: 7.0),
          decoration: BoxDecoration(
            color: DDColor.primary.shade400,
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 3.0),
              ),
            ],
          ),
          child: const Icon(
            CupertinoIcons.xmark,
            color: DDColor.white,
            size: 60.0,
          ),
        ),
        const SizedBox(height: 25.0),
        Text(
          "가입에 실패했어요",
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h2,
            color: DDColor.fontColor,
          ),
        ),
        const SizedBox(height: 1.0),
        Text(
          "[로그인]에서 이이디/비밀번호를 입력하시면\n다시 회원가입을 진행할 수 있습니다.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h4,
            color: DDColor.grey,
          ),
        ),
      ],
    );
  }
}
