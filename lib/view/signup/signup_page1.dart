import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';

class SignupPage1 extends StatefulWidget {
  final String title;
  final String content;
  final String buttonTitle;
  final VoidCallback? onPressed;

  const SignupPage1({
    Key? key,
    required this.title,
    required this.content,
    required this.buttonTitle,
    this.onPressed,
  }) : super(key: key);

  @override
  State<SignupPage1> createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  final ScrollController _controller = ScrollController();

  bool isBottom = false;

  @override
  void initState() {
    _controller.addListener(() {
      bool tmp = isBottom;
      isBottom = _controller.offset >= _controller.position.maxScrollExtent;
      if (tmp != isBottom) setState(() {});
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
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

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                decoration: BoxDecoration(
                    color: DDColor.white,
                    borderRadius: BorderRadius.circular(GlobalVariables.radius),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.05),
                      )
                    ]),
                child: ListView(
                  controller: _controller,
                  padding: const EdgeInsets.all(20.0),
                  physics: const BouncingScrollPhysics(),
                  children: [Text(widget.content)],
                ),
              ),
            ),

            DDButton(
              label: widget.buttonTitle,
              onPressed: isBottom
                  ? () async {
                      pageOpacity = 0.0;
                      setState(() {});
                      await Future.delayed(const Duration(milliseconds: 100));

                      widget.onPressed!();
                      _controller.jumpTo(0.0);
                      pageOpacity = 1.0;
                      setState(() {});
                    }
                  : null,
            ),
            const SizedBox(height: 50),

            ///
            ///
            ///
          ],
        ),
      ),
    );
  }
}
