import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/app_bar.dart';
import 'package:flutter/material.dart';

class SettingTextView extends StatefulWidget {
  final String title;
  final String content;

  const SettingTextView({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  _SettingTextViewState createState() => _SettingTextViewState();
}

class _SettingTextViewState extends State<SettingTextView> {
  final ScrollController _controller = ScrollController();
  bool isTop = true;

  @override
  void initState() {
    _controller.addListener(() {
      isTop = _controller.offset <= 10.0;
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
    return Scaffold(
      backgroundColor: DDColor.background,
      appBar: DDAppBar(context, title: "설정"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isTop)
            const Divider(
              height: 0.5,
              thickness: 0.5,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      controller: _controller,
                      padding: const EdgeInsets.only(bottom: 50.0),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 10.0),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h2,
                            color: DDColor.fontColor,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          widget.content,
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.bold,
                            fontSize: DDFontSize.h5,
                            color: DDColor.fontColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
