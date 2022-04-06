import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/material.dart';

class SignupPage3 extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onBackPressed;

  const SignupPage3({
    Key? key,
    this.onPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<SignupPage3> createState() => _SignupPage3State();
}

class _SignupPage3State extends State<SignupPage3> {
  TextEditingController _controller = TextEditingController();
  bool isIncorrect = false;

  @override
  void initState() {
    _controller.addListener(() {
      isIncorrect = _controller.text.length > 2;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "이메일로 인증번호를 발송했습니다",
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h4,
                  color: DDColor.grey,
                ),
              ),
            ),
            Center(
              child: Text(
                "인증번호를 입력해주세요",
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h15,
                  color: DDColor.fontColor,
                ),
              ),
            ),
            const SizedBox(height: 5.0),

            isIncorrect
                ? Center(
                    child: Text(
                      "인증번호가 일치하지 않습니다",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.primary,
                      ),
                    ),
                  )
                : const SizedBox(
                    height: DDFontSize.h4 + 2.0,
                  ),

            const SizedBox(height: 20.0),

            Stack(
              children: [
                SizedBox(
                  height: 0,
                  width: 0,
                  child: DDTextField(
                    autofocus: true,
                    fontSize: 0.0,
                    keyboardType: TextInputType.number,
                    controller: _controller,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 20.0),
                  width: 75.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: DDColor.disabled.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(GlobalVariables.radius),
                  ),
                  child: Text(
                    _controller.text.length >= 1 ? "*" : "",
                    style: TextStyle(
                      fontFamily: DDFontFamily.nanumSR,
                      fontWeight: DDFontWeight.extraBold,
                      fontSize: DDFontSize.h1,
                      color: DDColor.fontColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 20.0),
                  width: 75.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: DDColor.disabled.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(GlobalVariables.radius),
                  ),
                  child: Text(
                    _controller.text.length >= 2 ? "*" : "",
                    style: TextStyle(
                      fontFamily: DDFontFamily.nanumSR,
                      fontWeight: DDFontWeight.extraBold,
                      fontSize: DDFontSize.h1,
                      color: DDColor.fontColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50.0),

            Center(
              child: DDButton(
                width: 40.0,
                height: 40.0,
                label: "←",
                onPressed: widget.onBackPressed,
                color: DDColor.disabled,
              ),
            ),

            ///
            ///
            ///
          ],
        ),
      ),
    );
  }
}
