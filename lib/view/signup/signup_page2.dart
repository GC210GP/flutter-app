import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupPage2 extends StatefulWidget {
  final Function(String inputText)? onPressed;
  final VoidCallback? onBackPressed;
  final String title;
  final String errorMessage;
  final RegExp? validator;
  final Future<bool> Function(String)? correctionCheck;
  final bool isObscureText;
  final TextInputType? keyboardType;
  final bool isTransition;

  const SignupPage2({
    Key? key,
    required this.title,
    required this.errorMessage,
    this.validator,
    this.onPressed,
    this.onBackPressed,
    this.correctionCheck,
    this.isObscureText = false,
    this.keyboardType,
    this.isTransition = true,
  }) : super(key: key);

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final TextEditingController _controller = TextEditingController();
  bool isEmpty = true;
  bool isCorrect = true;

  @override
  void initState() {
    _controller.addListener(() {
      isEmpty = _controller.text.isEmpty;

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

  String inputValue = "";

  bool isPressed = false;

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
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    fontWeight: DDFontWeight.extraBold,
                    fontSize: DDFontSize.h15,
                    color: DDColor.fontColor,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              !isCorrect
                  ? Center(
                      child: Text(
                        widget.errorMessage,
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
              const SizedBox(height: 15.0),

              DDTextField(
                obscureText: widget.isObscureText,
                controller: _controller,
                onChanged: (value) => inputValue = value,
                keyboardType: widget.keyboardType,
              ),

              const SizedBox(height: 50.0),

              Center(
                child: Stack(
                  children: [
                    DDButton(
                      width: 100.0,
                      label: "확인",
                      onPressed: !isEmpty
                          ? () async {
                              // Regex 검사

                              if (widget.validator != null) {
                                isCorrect = widget.validator!
                                    .hasMatch(inputValue.trim());
                              }

                              // 사용자 지정 correction check
                              if (isCorrect && widget.correctionCheck != null) {
                                isCorrect = await widget
                                    .correctionCheck!(inputValue.trim());
                              }

                              if (isCorrect && widget.onPressed != null) {
                                pageOpacity = widget.isTransition ? .0 : 1.0;
                                isPressed = true;
                                setState(() {});
                                await Future.delayed(
                                    const Duration(milliseconds: 100));

                                widget.onPressed!(inputValue.trim());
                                if (widget.isTransition) {
                                  inputValue = "";
                                  _controller.text = "";
                                  pageOpacity = 1.0;
                                  isPressed = false;
                                }
                              }

                              setState(() {});
                            }
                          : null,
                    ),
                    if (!widget.isTransition && isPressed)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                          child: const CupertinoActivityIndicator(radius: 13.0),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),
              if (!isPressed)
                Center(
                  child: DDButton(
                    width: 40.0,
                    height: 40.0,
                    child: const Icon(Icons.arrow_back_rounded),
                    onPressed: () async {
                      if (widget.onBackPressed != null) {
                        pageOpacity = 0.0;
                        setState(() {});
                        await Future.delayed(const Duration(milliseconds: 100));

                        widget.onBackPressed!();

                        inputValue = "";
                        _controller.text = "";
                        pageOpacity = 1.0;
                      }
                    },
                    color: DDColor.disabled,
                  ),
                ),

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
