import 'package:app/model/association.dto.dart';
import 'package:app/model/person.dto.dart';
import 'package:app/model/post.dto.dart';
import 'package:app/util/chat/chat_data.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/community/community_board_view.dart';
import 'package:app/view/user_profile_view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/community_item.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBoardView extends StatefulWidget {
  final UserDto? userDto;
  final ChatFrom? chatFrom;
  final String? backLabel;
  final String? title;

  const UserBoardView({
    Key? key,
    this.userDto,
    this.backLabel,
    this.chatFrom,
    this.title,
  }) : super(key: key);

  @override
  _UserBoardViewState createState() => _UserBoardViewState();
}

class _UserBoardViewState extends State<UserBoardView> {
  final ScrollController _controller = ScrollController();
  bool isTop = true;

  List<PostDto> posts = [];

  @override
  void initState() {
    if (widget.userDto != null) getUserBoards();

    if (widget.backLabel != null) {
      _controller.addListener(() {
        isTop = _controller.offset <= 10.0;
        setState(() {});
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.backLabel != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.backLabel != null
          ? DDAppBar(context, title: widget.backLabel!)
          : null,
      backgroundColor: DDColor.background,
      body: Column(
        children: [
          if (widget.backLabel != null && !isTop)
            const Divider(
              height: 0.5,
              thickness: 0.5,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, (widget.title != null ? 35 : 0.0), 20, 0),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 50.0),
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                children: widget.userDto != null
                    ? [
                        Row(
                          children: [
                            DDPageTitleWidget(
                              title: widget.title != null
                                  ? widget.title!
                                  : widget.userDto!.nickname,
                              margin: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                            ),

                            // ??????

                            if (posts.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, bottom: 3.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: DDColor.white,
                                    width: 3.0,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: DDColor.primary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 3.0,
                                      offset: const Offset(0.0, 1.0),
                                    )
                                  ],
                                ),
                                width: 25.0,
                                height: 25.0,
                                alignment: Alignment.center,
                                child: Text(
                                  posts.length.toString(),
                                  style: const TextStyle(
                                    fontFamily: DDFontFamily.nanumSR,
                                    fontWeight: DDFontWeight.extraBold,
                                    fontSize: DDFontSize.h4,
                                    color: DDColor.white,
                                  ),
                                ),
                              ),

                            const Expanded(child: SizedBox()),

                            // ????????? ????????? ????????????
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(35),
                                  padding: const EdgeInsets.all(0.0),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UserProfileView(
                                        backLabel: "?????????",
                                        toId: widget.userDto!.uid,
                                      ),
                                    ),
                                  ),
                                  child: Image.network(
                                    widget.userDto!.profileImageLocation,
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            ///
                          ],
                        ),

                        ///

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(GlobalVariables.radius),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (posts.isNotEmpty)
                                for (PostDto i in posts)
                                  CommunityBoardItem(
                                    associationName:
                                        i.associationDto!.associationName,
                                    author: i.userNickname,
                                    title: i.title.length >= 10
                                        ? i.title.substring(0, 10)
                                        : i.title,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CommunityBoardView(
                                          chatFrom: widget.chatFrom,
                                          postDto: i,
                                        ),
                                      ),
                                    ).then(
                                      (value) => {},
                                    ),
                                  )
                              else
                                Container(
                                  height: 100,
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "???????????? ????????????.",
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
                      ]
                    : [
                        Container(
                          height: MediaQuery.of(context).size.height / 2.5,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "?????? ??????????????? ?????? ?????? ????????????\n???????????? ????????????!",
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

  getUserBoards() async {
    // ????????? ????????? ??? ???????????? ??????
    Map<String, dynamic> resultPosts = await GlobalVariables.httpConn
        .get(apiUrl: "/posts/users/${widget.userDto!.uid}");

    if (resultPosts['httpConnStatus'] == httpConnStatus.success) {
      for (Map<String, dynamic> post in resultPosts['data']) {
        int aid = post['associationResponseDto']['id'];

        posts.add(
          PostDto(
            pid: post['postResponseDto']["id"],
            title: post['postResponseDto']["title"] ?? "",
            content: post['postResponseDto']["content"] ?? "",
            associationId: aid,
            isActiveGiver: post['postResponseDto']["isActiveGiver"] ?? false,
            isActiveReceiver:
                post['postResponseDto']["isActiveReceiver"] ?? false,
            createdDate: DateTime.parse(post['postResponseDto']
                    ["createdDate"] ??
                GlobalVariables.defaultDateTime.toString()),
            modifiedDate: DateTime.parse(post['postResponseDto']
                    ["modifiedDate"] ??
                GlobalVariables.defaultDateTime.toString()),
            userId: post['postResponseDto']['userId'],
            userNickname: post['postResponseDto']['userNickname'],
            associationDto: AssociationDto(
              aid: post['associationResponseDto']['id'],
              associationName: post['associationResponseDto']
                  ['associationName'],
              createdDate: DateTime.parse(post['associationResponseDto']
                      ['createdDate'] ??
                  GlobalVariables.defaultDateTime.toString()),
              modifiedDate: DateTime.parse(post['associationResponseDto']
                      ['modifiedDate'] ??
                  GlobalVariables.defaultDateTime.toString()),
              uaid: aid,
            ),
          ),
        );
      }

      setState(() {});
    }
  }
}
