import 'package:app/model/association.dto.dart';
import 'package:app/model/post.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/util/toast.dart';
import 'package:app/view/community/community_board_view.dart';
import 'package:app/view/community/community_editor_view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/community_item.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  final AssociationDto associationDto;
  final bool isStarred;

  const CommunityView({
    Key? key,
    required this.associationDto,
    this.isStarred = false,
  }) : super(key: key);

  @override
  _CommunityViewState createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final ScrollController _controller = ScrollController();
  bool isTop = true;

  List<PostDto> posts = [];
  late bool isStarred;

  bool isStarredWorking = false;

  @override
  void initState() {
    isStarred = widget.isStarred;

    _controller.addListener(() {
      isTop = _controller.offset <= 10.0;
      setState(() {});
    });

    getCommunityBoards(widget.associationDto.aid, 0).then((value) {
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
                          DDPageTitleWidget(
                            title: widget.associationDto.associationName,
                            margin:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
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
                              onPressed: () => isStarred
                                  ? removeCommunityStar(
                                      widget.associationDto.uaid,
                                    )
                                  : addCommunityStar(
                                      widget.associationDto.aid,
                                    ),
                            ),
                          ),
                        ],
                      ),

                      ///
                      ///
                      ///

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
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CommunityEditorView(
                                  isModify: false,
                                  post: PostDto(
                                    pid: -1,
                                    title: "",
                                    content: "",
                                    associationId: widget.associationDto.aid,
                                    isActiveGiver: false,
                                    isActiveReceiver: false,
                                    createdDate:
                                        GlobalVariables.defaultDateTime,
                                    modifiedDate:
                                        GlobalVariables.defaultDateTime,
                                    userId: GlobalVariables.userDto!.uid,
                                    userNickname:
                                        GlobalVariables.userDto!.nickname,
                                  ),
                                ),
                              ),
                            ).then(
                              (value) => getCommunityBoards(
                                      widget.associationDto.aid, 0)
                                  .then(
                                (value) {
                                  setState(() {});
                                },
                              ),
                            ),
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
                        if (posts.isNotEmpty)
                          for (PostDto i in posts)
                            CommunityBoardItem(
                              author: i.userNickname,
                              title: i.title.length >= 10
                                  ? i.title.substring(0, 10)
                                  : i.title,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CommunityBoardView(
                                    postDto: i,
                                  ),
                                ),
                              ).then(
                                (value) => getCommunityBoards(
                                        widget.associationDto.aid, 0)
                                    .then((value) {
                                  setState(() {});
                                }),
                              ),
                            )
                        else
                          Container(
                            height: 100,
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "글이 없습니다.\n새 글을 작성해보세요!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: DDFontFamily.nanumSR,
                                fontWeight: DDFontWeight.extraBold,
                                fontSize: DDFontSize.h4,
                                color: DDColor.grey,
                              ),
                            ),
                          ),
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

  ///
  ///
  ///
  ///
  ///

  Future<List<String>> getCommunityBoards(int aid, int pageNum) async {
    posts.clear();

    Map<String, dynamic> result =
        await GlobalVariables.httpConn.get(apiUrl: "/posts", queryString: {
      "associationId": aid,
      "page": pageNum,
      // "size": 20,
      "sort": "modifiedDate,desc",
    });

    if (result['httpConnStatus'] == httpConnStatus.success) {
      // aid = result['data']['associationId'];
      List<dynamic> postRaws = result['data']['postResponseDto']['content'];

      for (var i in postRaws) {
        posts.add(
          PostDto(
            pid: i["id"],
            title: i["title"] ?? "",
            content: i["content"] ?? "",
            associationId: i["associationId"] ?? -1,
            isActiveGiver: i["isActiveGiver"] ?? false,
            isActiveReceiver: i["isActiveReceiver"] ?? false,
            createdDate: DateTime.parse(
                i["createdDate"] ?? GlobalVariables.defaultDateTime.toString()),
            modifiedDate: DateTime.parse(i["modifiedDate"] ??
                GlobalVariables.defaultDateTime.toString()),
            userId: i['userId'],
            userNickname: i['userNickname'],
            // associationDto: AssociationDto(
            //   aid: associationRaw['id'],
            //   associationName: associationRaw['associationName'],
            //   createdDate: DateTime.parse(
            //       associationRaw['createdDate'] ?? GlobalVariables.defaultDateTime.toString()),
            //   modifiedDate: DateTime.parse(
            //       associationRaw['modifiedDate'] ?? GlobalVariables.defaultDateTime.toString()),
            //   uaid: -1, // TODO 참고
            // ),
          ),
        );
      }
    }

    return [];
  }

  removeCommunityStar(int uaid) async {
    if (!isStarredWorking) {
      isStarredWorking = true;

      // TODO: 추가할 때는 uid를 모름
      if (uaid == -1) {
        return;
      }

      Map<String, dynamic> resultAssociation = await GlobalVariables.httpConn
          .delete(apiUrl: "/user-associations/$uaid");

      if (resultAssociation['httpConnStatus'] == httpConnStatus.success) {
        DDToast.showToast("즐겨찾기에서 삭제되었어요");
        setState(() {
          isStarred = false;
        });
      }
      isStarredWorking = false;
    }
  }

  addCommunityStar(int aid) async {
    if (!isStarredWorking) {
      isStarredWorking = true;
      Map<String, dynamic> resultAssociation = await GlobalVariables.httpConn
          .post(apiUrl: "/user-associations", body: {"associationId": "$aid"});

      if (resultAssociation['httpConnStatus'] == httpConnStatus.success) {
        DDToast.showToast("즐겨찾기에 추가되었어요 🎉");
        setState(() {
          isStarred = true;
        });
      }
      isStarredWorking = false;
    }
  }
}
