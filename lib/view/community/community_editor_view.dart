import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/material.dart';

class CommunityEditorView extends StatefulWidget {
  const CommunityEditorView({Key? key}) : super(key: key);

  @override
  _CommunityEditorViewState createState() => _CommunityEditorViewState();
}

class _CommunityEditorViewState extends State<CommunityEditorView> {
  bool isModify = false;
  FocusNode focusNodeTitle = FocusNode();
  FocusNode focusNodeContent = FocusNode();

  @override
  void initState() {
    focusNodeTitle.addListener(() {
      setState(() {});
    });
    focusNodeContent.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNodeTitle.dispose();
    focusNodeContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DDColor.background,
      appBar: DDAppBar(context, title: "뒤로"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageTitleWidget(title: "글쓰기"),
            Text(
              "제목",
              style: TextStyle(
                fontFamily: DDFontFamily.nanumSR,
                fontWeight: DDFontWeight.extraBold,
                fontSize: DDFontSize.h4,
                color: DDColor.grey,
              ),
            ),
            const SizedBox(height: 5.0),
            DDTextField(
              focusNode: focusNodeTitle,
            ),

            //
            const SizedBox(height: 10.0),
            //

            Text(
              "내용",
              style: TextStyle(
                fontFamily: DDFontFamily.nanumSR,
                fontWeight: DDFontWeight.extraBold,
                fontSize: DDFontSize.h4,
                color: DDColor.grey,
              ),
            ),
            const SizedBox(height: 5.0),

            Expanded(
              child: DDTextField(
                isMultiline: true,
                focusNode: focusNodeContent,
              ),
            ),
            SizedBox(height: 10.0),
            if (!focusNodeContent.hasFocus && !focusNodeTitle.hasFocus)
              DDButton(label: isModify ? "수정하기" : "등록하기", onPressed: () {})
            else
              DDButton(
                  label: "수정완료",
                  color: DDColor.grey,
                  onPressed: () {
                    focusNodeTitle.unfocus();
                    focusNodeContent.unfocus();
                  }),
            if (!focusNodeContent.hasFocus && !focusNodeTitle.hasFocus)
              SizedBox(height: 50.0)
            else
              SizedBox(height: 10.0)
          ],
        ),
      ),
    );
  }
}
