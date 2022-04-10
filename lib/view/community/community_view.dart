import 'package:app/model/association.dto.dart';
import 'package:app/model/post.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
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
                          PageTitleWidget(
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
                            onPressed: editPost,
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

  editPost({int? boardId}) async {
    if (boardId == null) {
      Map<String, dynamic> result = await GlobalVariables.httpConn.post(
        apiUrl: "/posts",
        body: {
          "title": "",
          "content": "",
          "isActive": "false",
        },
      );
      if (result['httpConnStatus'] == httpConnStatus.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommunityEditorView(
              post: PostDto(
                pid: result['id'],
                title: result['title'] ?? "",
                content: result['content'] ?? "",
                isActiveGiver: result['isActiveGiver'] ?? false,
                isActiveReceiver: result['isActiveReceiver'] ?? false,
                cratedDate: DateTime.parse(
                    result["createdDate"] ?? DateTime(1).toString()),
                modifiedDate: DateTime.parse(
                    result["modifiedDate"] ?? DateTime(1).toString()),
                userId: result['userId'],
                userNickname: result['userNickname'],
              ),
            ),
          ),
        );
      }
    } else {
      Map<String, dynamic> result = await GlobalVariables.httpConn.get(
        apiUrl: "/posts/$boardId",
      );
      if (result['httpConnStatus'] == httpConnStatus.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommunityEditorView(
              post: PostDto(
                pid: result['data']['id'],
                title: result['data']['title'] ?? "",
                content: result['data']['content'] ?? "",
                isActiveGiver: result['data']['isActiveGiver'] ?? false,
                isActiveReceiver: result['data']['isActiveReceiver'] ?? false,
                cratedDate: DateTime.parse(
                    result['data']["createdDate"] ?? DateTime(1).toString()),
                modifiedDate: DateTime.parse(
                    result['data']["modifiedDate"] ?? DateTime(1).toString()),
                userId: result['data']['userId'],
                userNickname: result['data']['userNickname'],
              ),
            ),
          ),
        );
      }
    }
  }

  Future<List<String>> getCommunityBoards(int aid, int pageNum) async {
    Map<String, dynamic> result =
        await GlobalVariables.httpConn.get(apiUrl: "/posts", queryString: {
      "associationId": aid,
      "page": pageNum,
      "size": 20,
      "sort": "modifiedDate,desc",
    });

    if (result['httpConnStatus'] == httpConnStatus.success) {
      for (var i in result['data']['content']) {
        posts.add(
          PostDto(
              pid: i["id"],
              title: i["title"] ?? "",
              content: i["content"] ?? "",
              isActiveGiver: i["isActiveGiver"] ?? false,
              isActiveReceiver: i["isActiveReceiver"] ?? false,
              cratedDate:
                  DateTime.parse(i["createdDate"] ?? DateTime(1).toString()),
              modifiedDate:
                  DateTime.parse(i["modifiedDate"] ?? DateTime(1).toString()),
              userId: i['userId'],
              userNickname: i['userNickname']),
        );
      }
    }

    return [];
  }

  removeCommunityStar(int uaid) async {
    Map<String, dynamic> resultAssociation = await GlobalVariables.httpConn
        .delete(apiUrl: "/user-associations/$uaid");

    if (resultAssociation['httpConnStatus'] == httpConnStatus.success) {
      setState(() {
        isStarred = false;
      });
    }
  }

  addCommunityStar(int aid) async {
    Map<String, dynamic> resultAssociation = await GlobalVariables.httpConn
        .post(apiUrl: "/user-associations", body: {"associationId": "$aid"});

    if (resultAssociation['httpConnStatus'] == httpConnStatus.success) {
      setState(() {
        isStarred = true;
      });
    }
  }
}
