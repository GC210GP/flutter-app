import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 회원가입 완료
class SignPage7 extends StatefulWidget {
  const SignPage7({Key? key}) : super(key: key);

  @override
  State<SignPage7> createState() => _SignPage7State();
}

class _SignPage7State extends State<SignPage7> {
  _Status status = _Status.success;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status == _Status.processing) const Processing(),
        if (status == _Status.success)
          Column(
            children: [
              SizedBox(height: 50.0),
              Complete(),
              SizedBox(height: 50.0),
              DDButton(
                width: 120,
                label: "로그인",
              ),
            ],
          ),
        if (status == _Status.fail)
          Column(
            children: [
              SizedBox(height: 50.0),
              Fail(),
              SizedBox(height: 50.0),
              DDButton(
                width: 120,
                label: "돌아가기",
              ),
            ],
          ),
      ],
    );
  }
}

enum _Status {
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
          width: 150.0,
          height: 150.0,
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(150.0),
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
            size: 100.0,
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
          width: 150.0,
          height: 150.0,
          padding: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            color: Colors.redAccent.shade400,
            borderRadius: BorderRadius.circular(150.0),
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
            size: 80.0,
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
          "잠시 후 다시 시도해주세요 😭",
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
