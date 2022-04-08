import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';

import '../message_view.dart';

class CommunityBoardView extends StatefulWidget {
  const CommunityBoardView({Key? key}) : super(key: key);

  @override
  _CommunityBoardViewState createState() => _CommunityBoardViewState();
}

class _CommunityBoardViewState extends State<CommunityBoardView> {
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
      appBar: DDAppBar(context, title: "뒤로"),
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
                        SizedBox(height: 10.0),
                        Text(
                          "제 친구가 많이 아파요..ㅠ",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h3,
                            color: DDColor.fontColor,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "테평주민",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h4,
                            color: DDColor.grey,
                          ),
                        ),
                        SizedBox(height: 35),
                        Text(
                          "안녕하세요.. 지금 태평에 살고 있는데 친구가 서울대병원에 입원중입니다. \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n친구가 혈액암으로 투병중인데 요즘 코로나라 헌혈을 받기가 너무 힘들다고 하네요.. \n\n혹시 현혈이 가능하시다면 연락바랍니다!",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h4,
                            color: DDColor.fontColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DDButton(
                    label: "대화 시작하기",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MessageView(
                          fromId: GlobalVariables.userIdx,
                          toId: 4,
                          toName: "태평주민",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
