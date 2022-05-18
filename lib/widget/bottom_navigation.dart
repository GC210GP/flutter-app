import 'dart:io';

import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({
    Key? key,
    required this.index,
    required this.onPressed,
    this.controller,
  }) : super(key: key);

  final int index;

  final VoidCallback onPressed;
  final CustomButtomNavigationController? controller;

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  final horizontalMargin = const SizedBox(width: 18);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20.0),
      decoration: const BoxDecoration(
        color: DDColor.widgetBackgroud,
        // borderRadius: Platform.isIOS
        //     ? const BorderRadius.only(
        //         topLeft: Radius.circular(25),
        //         topRight: Radius.circular(25),
        //       )
        //     : null,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 5),
            spreadRadius: 0.0,
            blurRadius: 15.0,
          )
        ],
      ),
      child: Row(
        children: [
          horizontalMargin,
          Expanded(
            child: BottomIcon(
              index: 1,
              currIndex: widget.index,
              icons: CupertinoIcons.house_alt_fill,
              label: "홈",
              onPressed: widget.onPressed,
              controller: widget.controller,
            ),
          ),
          Expanded(
            child: BottomIcon(
              index: 2,
              currIndex: widget.index,
              icons: CupertinoIcons.chat_bubble_fill,
              label: "메시지",
              onPressed: widget.onPressed,
              controller: widget.controller,
            ),
          ),
          Expanded(
            child: BottomIcon(
              index: 3,
              currIndex: widget.index,
              icons: Icons.my_library_books_rounded,
              label: "커뮤니티",
              onPressed: widget.onPressed,
              controller: widget.controller,
            ),
          ),
          Expanded(
            child: BottomIcon(
              index: 4,
              currIndex: widget.index,
              icons: CupertinoIcons.doc_fill,
              label: "나의 글",
              onPressed: widget.onPressed,
              controller: widget.controller,
            ),
          ),
          Expanded(
            child: BottomIcon(
              index: 5,
              currIndex: widget.index,
              icons: Icons.equalizer_rounded,
              label: "설정",
              onPressed: widget.onPressed,
              controller: widget.controller,
            ),
          ),
          horizontalMargin,
        ],
      ),
    );
  }
}

///
///
///

class BottomIcon extends StatelessWidget {
  final String label;
  final IconData icons;
  final int index;
  final int currIndex;
  final VoidCallback? onPressed;
  final CustomButtomNavigationController? controller;

  const BottomIcon({
    Key? key,
    required this.label,
    required this.icons,
    required this.index,
    required this.currIndex,
    this.onPressed,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        if (controller != null) controller!.currentIdx = index;
        if (onPressed != null) onPressed!();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icons,
            color: index == currIndex ? DDColor.primary : DDColor.disabled,
            size: 25,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: DDFontFamily.nanumSR,
              fontWeight: DDFontWeight.extraBold,
              fontSize: DDFontSize.h6,
              color: index == currIndex ? DDColor.primary : DDColor.disabled,
            ),
          ),
        ],
      ),
    );
  }
}

///
///
///

class CustomButtomNavigationController {
  int currentIdx = 0;
}
