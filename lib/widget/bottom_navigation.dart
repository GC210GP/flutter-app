import 'dart:io';

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
      height: Platform.isIOS ? 115 : 95,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Platform.isIOS
            ? BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )
            : null,
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, -3),
            spreadRadius: 0.0,
            blurRadius: 7.0,
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 23),
          Row(
            children: [
              horizontalMargin,
              Expanded(
                child: buttonItem(
                  index: 1,
                  currIndex: widget.index,
                  icons: CupertinoIcons.house_alt_fill,
                  label: "홈",
                  onPressed: widget.onPressed,
                ),
              ),
              Expanded(
                child: buttonItem(
                  index: 2,
                  currIndex: widget.index,
                  icons: CupertinoIcons.chat_bubble_fill,
                  label: "메시지",
                  onPressed: widget.onPressed,
                ),
              ),
              Expanded(
                child: buttonItem(
                  index: 3,
                  currIndex: widget.index,
                  icons: Icons.my_library_books_rounded,
                  label: "커뮤니티",
                  onPressed: widget.onPressed,
                ),
              ),
              Expanded(
                child: buttonItem(
                  index: 4,
                  currIndex: widget.index,
                  icons: Icons.equalizer_rounded,
                  label: "설정",
                  onPressed: widget.onPressed,
                ),
              ),
              horizontalMargin,
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonItem({
    required String label,
    required IconData icons,
    required int index,
    required int currIndex,
    required VoidCallback onPressed,
  }) =>
      CupertinoButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (widget.controller != null) {
            widget.controller!.currentIdx = index;
          }
          onPressed();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icons,
              color: index == currIndex
                  ? Colors.red.shade400
                  : Colors.grey.shade300,
              size: 30,
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: "NanumSR",
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: index == currIndex
                    ? Colors.red.shade400
                    : Colors.grey.shade300,
              ),
            ),
          ],
        ),
      );
}

class CustomButtomNavigationController {
  int currentIdx = 0;
}
