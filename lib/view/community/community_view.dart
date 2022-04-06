import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/community/community_board_view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/community_item.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  _CommunityViewState createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final ScrollController _controller = ScrollController();
  bool isTop = true;
  bool isStarred = false;

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
      appBar: DDAppBar(context, title: "커뮤니티"),
      backgroundColor: DDColor.background,
      body: Column(
        children: [
          if (!isTop)
            const Divider(
              height: 0.5,
              thickness: 0.5,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 50.0),
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          const PageTitleWidget(
                            title: "#성남시",
                            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 10.0, bottom: 5.0),
                            child: CupertinoButton(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                CupertinoIcons.star_fill,
                                color: isStarred
                                    ? Colors.yellowAccent.shade700
                                    : DDColor.disabled,
                                size: 20.0,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: .0,
                        bottom: .0,
                        right: .0,
                        child: Center(
                          child: DDButton(
                            label: "글쓰기",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.edit_rounded,
                                  size: DDFontSize.h4,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  "글쓰기 ",
                                  style: TextStyle(
                                    fontFamily: DDFontFamily.nanumSR,
                                    color: DDColor.white,
                                    fontWeight: DDFontWeight.extraBold,
                                    fontSize: DDFontSize.h4,
                                  ),
                                ),
                              ],
                            ),
                            color: DDColor.grey.withOpacity(0.5),
                            height: 35.0,
                            width: 85,
                            onPressed: () => {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(GlobalVariables.radius),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CommunityBoardItem(
                            author: "성남주민", title: "성남병원 지정헌혈 부탁드립니다.."),
                        CommunityBoardItem(
                            author: "분당주민", title: "지금 제생병원에 있습니다. 정말 급합니다!"),
                        CommunityBoardItem(
                            author: "이매주민", title: "서울대병원 지정헌혈 부탁드립니다.."),
                        CommunityBoardItem(
                            author: "위례주민", title: "분당제생병원 지정헌혈 부탁드립니다.."),
                        for (int i = 0; i < 20; i++)
                          CommunityBoardItem(
                              author: "정자주민", title: "저희 가족을 도와주세요"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget item({required String author, required String title}) => Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author,
                style: TextStyle(
                  fontFamily: "NanumSR",
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontFamily: "NanumSR",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
        ),
      );
}
