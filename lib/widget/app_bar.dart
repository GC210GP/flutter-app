import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSizeWidget DDAppBar(
  BuildContext context, {
  String title = "",
  List<Widget>? actions,
}) =>
    AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: CupertinoButton(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Icon(
          CupertinoIcons.chevron_back,
          size: 30,
          color: DDColor.grey,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: actions,
      centerTitle: false,
      titleSpacing: -10.0,
      title: CupertinoButton(
        alignment: Alignment.centerLeft,
        onPressed: () => Navigator.pop(context),
        padding: const EdgeInsets.all(0.0),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h3,
            color: DDColor.grey,
          ),
        ),
      ),
    );
