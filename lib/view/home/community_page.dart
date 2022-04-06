import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/community_item.dart';
import 'package:app/widget/input_box.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Status {
  searching,
  starred,
  searchResult,
}

class CommunityPageView extends StatefulWidget {
  const CommunityPageView({Key? key}) : super(key: key);

  @override
  _CommunityPageViewState createState() => _CommunityPageViewState();
}

class _CommunityPageViewState extends State<CommunityPageView> {
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

  Status status = Status.starred;

  double pageOpacity = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {});
    });
    textController.addListener(() {
      setState(() {});
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        status = Status.searching;
      } else if (textController.text.isEmpty) {
        status = Status.starred;
      } else {
        status = Status.searchResult;
      }

      setState(() {});
    });

    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      pageOpacity = 1;
      scrollController.jumpTo(110.0);
      setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // 검색
                    Container(
                      height: 50.0,
                      margin: const EdgeInsets.only(bottom: 60),
                      child: Stack(
                        children: [
                          DDTextField(
                            padding: EdgeInsets.fromLTRB(45, 21, 15, 0),
                            hintText: "커뮤니티 검색...",
                            focusNode: focusNode,
                            controller: textController,
                          ),
                          Positioned(
                            top: 0,
                            bottom: 3,
                            left: 15.0,
                            child: Icon(
                              CupertinoIcons.search,
                              color: DDColor.disabled,
                              size: 25.0,
                            ),
                          ),
                          if (textController.text.isNotEmpty)
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: 15.0,
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: DDColor.disabled,
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  textController.text = "";
                                  focusNode.unfocus();
                                  status = Status.starred;
                                  scrollController.jumpTo(110.0);
                                  setState(() {});
                                },
                              ),
                            )
                        ],
                      ),
                    ),

                    if (status == Status.starred) StarredItems(),
                    if (status == Status.searchResult)
                      SearchedItem(searchQuery: textController.text),

                    ///
                    ///
                    ///
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onStarPressed;
  final String title;
  final bool? isStarred;
  final Color? hashtagColor;

  const CommunityItem({
    Key? key,
    required this.title,
    this.isStarred,
    this.onPressed,
    this.onStarPressed,
    this.hashtagColor,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "#",
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h3,
                  color: hashtagColor ?? DDColor.grey,
                ),
              ),
              const SizedBox(width: 3.0),
              Text(
                title,
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.bold,
                  fontSize: DDFontSize.h3,
                  color: DDColor.fontColor,
                ),
              ),
              if (isStarred != null)
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        CupertinoIcons.star_fill,
                        color: isStarred!
                            ? Colors.yellowAccent.shade700
                            : DDColor.disabled,
                      ),
                      onPressed: onStarPressed,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchedItem extends StatelessWidget {
  final String searchQuery;
  const SearchedItem({
    required this.searchQuery,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(GlobalVariables.radius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < 5; i++)
                    CommunityItem(
                      title: "가천대$i",
                      isStarred: true,
                    ),
                  CommunityItem(
                    title: '"$searchQuery" 추가하기',
                    hashtagColor: DDColor.primary,
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0)
          ],
        )
      ],
    );
  }
}

class StarredItems extends StatelessWidget {
  const StarredItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 10; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  const PageTitleWidget(
                    title: "#가천대",
                    margin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Positioned(
                    right: 0,
                    height: 30.0,
                    width: 30.0,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0, bottom: 5.0),
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          CupertinoIcons.star_fill,
                          color: Colors.yellowAccent.shade700,
                          size: 20.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(GlobalVariables.radius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < 3; i++)
                      CommunityBoardItem(
                          author: "성남주민1", title: "성남병원 지정헌혈 부탁드립니다.."),
                    CommunityBoardItem(
                      author: "",
                      title: "더보기\n",
                      fontColor: DDColor.grey,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0)
            ],
          )
      ],
    );
  }
}
