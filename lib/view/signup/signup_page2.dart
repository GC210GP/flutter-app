import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/material.dart';

class SignupPage2 extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onBackPressed;
  final String title;
  final String errorMessage;

  const SignupPage2({
    Key? key,
    required this.title,
    required this.errorMessage,
    this.onPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final TextEditingController _controller = TextEditingController();
  bool isNotEmpty = false;
  bool isIncorrect = true;

  @override
  void initState() {
    _controller.addListener(() {
      isNotEmpty = _controller.text.isNotEmpty;

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
                widget.title,
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
                      widget.errorMessage,
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
              controller: _controller,
            ),

            const SizedBox(height: 50.0),

            Center(
              child: DDButton(
                width: 100.0,
                label: "확인",
                onPressed: isNotEmpty ? widget.onPressed : null,
              ),
            ),

            const SizedBox(height: 20.0),
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
