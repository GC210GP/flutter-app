import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/cupertino.dart';

class CommunityBoardItem extends StatelessWidget {
  final String author;
  final String title;
  final Color? fontColor;
  final VoidCallback? onPressed;

  const CommunityBoardItem({
    Key? key,
    required this.author,
    required this.title,
    this.fontColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: DDColor.widgetBackgroud,
        border: Border(
          bottom: BorderSide(
            color: DDColor.background,
          ),
        ),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(.0),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                author,
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.bold,
                  fontSize: DDFontSize.h6,
                  color: DDColor.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.bold,
                  fontSize: DDFontSize.h5,
                  color: fontColor ?? DDColor.fontColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
