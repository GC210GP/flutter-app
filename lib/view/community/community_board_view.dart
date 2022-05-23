import 'package:app/model/association.dto.dart';
import 'package:app/model/post.dto.dart';
import 'package:app/util/chat/chat_data.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/community/community_editor_view.dart';
import 'package:app/view/user_profile_view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import '../message_view.dart';

class CommunityBoardView extends StatefulWidget {
  final PostDto postDto;
  final ChatFrom? chatFrom;

  const CommunityBoardView({
    Key? key,
    required this.postDto,
    this.chatFrom,
  }) : super(key: key);

  @override
  _CommunityBoardViewState createState() => _CommunityBoardViewState();
}

class _CommunityBoardViewState extends State<CommunityBoardView> {
  final ScrollController _controller = ScrollController();
  bool isTop = true;

  late PostDto postDto;
  String toImgSrc = GlobalVariables.defaultImgUrl;

  @override
  void initState() {
    postDto = widget.postDto;

    _controller.addListener(() {
      isTop = _controller.offset <= 10.0;
      setState(() {});
    });

    GlobalVariables.httpConn.get(
      apiUrl: "/users",
      queryString: {"userId": widget.postDto.userId},
    ).then((result) {
      if (result['httpConnStatus'] == httpConnStatus.success) {
        toImgSrc = result['data']['profileImageLocation'] ??
            GlobalVariables.defaultImgUrl;
        setState(() {});
      }
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
      appBar: DDAppBar(context, title: "뒤로", actions: [
        Center(
          child: DDButton(
            child: Icon(
              CupertinoIcons.question_circle,
              size: 25,
              color: DDColor.grey,
            ),
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(right: 25.0),
            fontColor: DDColor.white,
            color: DDColor.background,
            fontWeight: DDFontWeight.bold,
            fontSize: DDFontSize.h4,
            onPressed: () => showDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                title: const Text("도움이 필요하신가요?"),
                content: const Text("메뉴를 선택해주세요"),
                actions: [
                  CupertinoButton(
                    child: Text(
                      "지정헌혈 관련 안내사항",
                      style: TextStyle(color: DDColor.primary),
                    ),
                    onPressed: () => url.launch(
                      "https://biss.bloodinfo.net/direct_donation_hos.jsp",
                      forceWebView: true,
                    ),
                  ),
                  CupertinoButton(
                    child: Text(
                      "사용자 신고",
                      style: TextStyle(color: DDColor.primary),
                    ),
                    onPressed: () => url.launch(
                      Uri(
                        scheme: 'mailto',
                        path: 'doubld@gmail.com',
                        query: GlobalVariables.emailQuery(
                            GlobalVariables.userDto!.name),
                      ).toString(),
                    ),
                  ),
                  CupertinoButton(
                    child: const Text("아니오"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
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
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postDto.title,
                                    style: TextStyle(
                                      fontFamily: DDFontFamily.nanumSR,
                                      fontWeight: DDFontWeight.extraBold,
                                      fontSize: DDFontSize.h3,
                                      color: DDColor.fontColor,
                                    ),
                                  ),
                                  const SizedBox(height: 3.0),
                                  SizedBox(
                                    height: DDFontSize.h3,
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0.0),
                                      alignment: Alignment.centerLeft,
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => UserProfileView(
                                            backLabel: "커뮤니티",
                                            toId: postDto.userId,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        postDto.associationDto == null
                                            ? postDto.userNickname
                                            : "${postDto.userNickname}  (#${postDto.associationDto!.associationName})",
                                        style: TextStyle(
                                          fontFamily: DDFontFamily.nanumSR,
                                          fontWeight: DDFontWeight.extraBold,
                                          fontSize: DDFontSize.h4,
                                          color: DDColor.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            CupertinoButton(
                              borderRadius: BorderRadius.circular(45),
                              padding: const EdgeInsets.all(0.0),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserProfileView(
                                    backLabel: "메시지",
                                    toId: postDto.userId,
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: Image.network(
                                  toImgSrc,
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // 글 수정 버튼
                            // if (postDto.userId == GlobalVariables.userDto!.uid)
                            //   Expanded(
                            //     child: Container(
                            //       alignment: Alignment.centerRight,
                            //       child: DDButton(
                            //         width: 35,
                            //         height: 35,
                            //         child: const Icon(
                            //           Icons.edit_rounded,
                            //           size: 20,
                            //         ),
                            //         color: DDColor.grey,
                            //         onPressed: () => Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (_) => CommunityEditorView(
                            //               post: widget.postDto,
                            //             ),
                            //           ),
                            //         ).then((_) async {
                            //           postDto =
                            //               (await getPost(widget.postDto.pid))!;
                            //           setState(() {});
                            //         }),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),

                        ///

                        // 수혈자 / 헌혈자 상태표시줄

                        // Container(
                        //   margin: const EdgeInsets.fromLTRB(0, 15, 0, 25),
                        //   padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        //   decoration: BoxDecoration(
                        //       color: DDColor.white,
                        //       borderRadius: BorderRadius.circular(
                        //         GlobalVariables.radius,
                        //       ),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black.withOpacity(0.1),
                        //           offset: const Offset(0.0, 3.0),
                        //           blurRadius: 5,
                        //         )
                        //       ]),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: Center(
                        //           child: Text(
                        //             "수혈자 헌혈 여부: ${widget.postDto.isActiveGiver ? 'O' : 'X'}",
                        //             style: TextStyle(
                        //               fontFamily: DDFontFamily.nanumSR,
                        //               fontWeight: DDFontWeight.bold,
                        //               fontSize: DDFontSize.h5,
                        //               color: DDColor.grey,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: Center(
                        //           child: Text(
                        //             "현혈자 수락: ${widget.postDto.isActiveReceiver ? 'O' : 'X'}",
                        //             style: TextStyle(
                        //               fontFamily: DDFontFamily.nanumSR,
                        //               fontWeight: DDFontWeight.bold,
                        //               fontSize: DDFontSize.h5,
                        //               color: DDColor.grey,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        ///

                        const SizedBox(height: 30),

                        Text(
                          postDto.content,
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
                    label: (postDto.userId == GlobalVariables.userDto!.uid)
                        ? "글 수정하기"
                        : "대화 시작하기",
                    onPressed: (postDto.userId == GlobalVariables.userDto!.uid)
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CommunityEditorView(
                                  isModify: true,
                                  post: widget.postDto,
                                ),
                              ),
                            ).then((_) async {
                              postDto = (await getPost(widget.postDto.pid))!;
                              setState(() {});
                            })
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MessageView(
                                  chatFrom: widget.chatFrom,
                                  fromId: GlobalVariables.userDto!.uid,
                                  toId: postDto.userId,
                                ),
                              ),
                            ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height /
                                MediaQuery.of(context).size.width >=
                            1.8)
                        ? 50.0
                        : 30.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<PostDto?> getPost(int pid) async {
    Map<String, dynamic> result = await GlobalVariables.httpConn.get(
      apiUrl: "/posts/$pid",
    );

    Map<String, dynamic> associationRaw =
        result['data']['associationResponseDto'];
    Map<String, dynamic> postRaw = result['data']['postResponseDto'];

    if (result['httpConnStatus'] == httpConnStatus.success) {
      return PostDto(
        pid: postRaw['id'],
        title: postRaw['title'] ?? "",
        associationId: postRaw["associationId"] ?? -1,
        content: postRaw['content'] ?? "",
        isActiveGiver: postRaw['isActiveGiver'] ?? false,
        isActiveReceiver: postRaw['isActiveReceiver'] ?? false,
        createdDate: DateTime.parse(postRaw["createdDate"] ??
            GlobalVariables.defaultDateTime.toString()),
        modifiedDate: DateTime.parse(postRaw["modifiedDate"] ??
            GlobalVariables.defaultDateTime.toString()),
        userId: postRaw['userId'],
        userNickname: postRaw['userNickname'],
        associationDto: AssociationDto(
          aid: associationRaw['id'],
          associationName: associationRaw['associationName'],
          createdDate: DateTime.parse(associationRaw['createdDate'] ??
              GlobalVariables.defaultDateTime.toString()),
          modifiedDate: DateTime.parse(associationRaw['modifiedDate'] ??
              GlobalVariables.defaultDateTime.toString()),
          uaid: -1, // TODO 참고
        ),
      );
    }
    return null;
  }
}
