import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';

class SignupPage3 extends StatefulWidget {
  // final VoidCallback? onBackPressed;
  final Future<bool> Function(int code)? onCheckValidation;
  final String email;

  const SignupPage3({
    Key? key,
    required this.email,
    // this.onBackPressed,
    this.onCheckValidation,
  }) : super(key: key);

  @override
  State<SignupPage3> createState() => _SignupPage3State();
}

class _SignupPage3State extends State<SignupPage3> {
  final TextEditingController _controller = TextEditingController();
  bool isCorrect = true;
  bool isTyped = false;
  bool isDone = false;

  @override
  void initState() {
    _controller.addListener(() async {
      if (_controller.text.length >= 2) {
        if (widget.onCheckValidation != null) {
          setState(() {});
          isTyped = true;
          isCorrect =
              await widget.onCheckValidation!(int.parse(_controller.text));

          if (!isCorrect) {
            _controller.clear();
            isTyped = false;
          }

          setState(() {});
        }
      } else {
        isTyped = false;
      }

      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      pageOpacity = 1.0;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double pageOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: Center(
        child: SizedBox(
          width: 320.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  widget.email,
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    fontWeight: DDFontWeight.extraBold,
                    fontSize: DDFontSize.h5,
                    color: DDColor.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  "이메일로 인증번호를 발송했습니다",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    fontWeight: DDFontWeight.extraBold,
                    fontSize: DDFontSize.h4,
                    color: DDColor.grey,
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              Center(
                child: Text(
                  "인증번호를 입력해주세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    fontWeight: DDFontWeight.extraBold,
                    fontSize: DDFontSize.h15,
                    color: DDColor.fontColor,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),

              !isCorrect
                  ? Center(
                      child: Text(
                        "인증번호가 일치하지 않습니다",
                        textAlign: TextAlign.center,
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

              Stack(
                children: [
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
                          borderRadius:
                              BorderRadius.circular(GlobalVariables.radius),
                        ),
                        child: Text(
                          _controller.text.length >= 1 ? "*" : "",
                          textAlign: TextAlign.center,
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
                          borderRadius:
                              BorderRadius.circular(GlobalVariables.radius),
                        ),
                        child: Text(
                          _controller.text.length >= 2 ? "*" : "",
                          textAlign: TextAlign.center,
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
                  if (isTyped)
                    const Positioned.fill(
                      child: SizedBox(
                        width: 15.0,
                        height: 15.0,
                        child: CupertinoActivityIndicator(
                          radius: 15.0,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 50.0),

              // Center(
              //   child: DDButton(
              //     width: 40.0,
              //     height: 40.0,
              //     child: const Icon(Icons.arrow_back_rounded),
              //     onPressed: widget.onBackPressed,
              //     color: DDColor.disabled,
              //   ),
              // ),

              ///
              ///
              ///
            ],
          ),
        ),
      ),
    );
  }
}
