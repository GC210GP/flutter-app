import 'package:app/model/association.dto.dart';
import 'package:app/model/post.dto.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/community/community_editor_view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';

import '../message_view.dart';

class CommunityBoardView extends StatefulWidget {
  final PostDto postDto;

  const CommunityBoardView({
    Key? key,
    required this.postDto,
  }) : super(key: key);

  @override
  _CommunityBoardViewState createState() => _CommunityBoardViewState();
}

class _CommunityBoardViewState extends State<CommunityBoardView> {
  final ScrollController _controller = ScrollController();
  bool isTop = true;

  late PostDto postDto;

  @override
  void initState() {
    postDto = widget.postDto;

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
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
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
                                Text(
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
                              ],
                            ),
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
                        const SizedBox(height: 35.0),
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
                                  fromId: GlobalVariables.userDto!.uid,
                                  toId: postDto.userId,
                                ),
                              ),
                            ),
                  ),
                  const SizedBox(height: 75),
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
        createdDate:
            DateTime.parse(postRaw["createdDate"] ?? DateTime(1).toString()),
        modifiedDate:
            DateTime.parse(postRaw["modifiedDate"] ?? DateTime(1).toString()),
        userId: postRaw['userId'],
        userNickname: postRaw['userNickname'],
        associationDto: AssociationDto(
          aid: associationRaw['id'],
          associationName: associationRaw['associationName'],
          createdDate: DateTime.parse(
              associationRaw['createdDate'] ?? DateTime(1).toString()),
          modifiedDate: DateTime.parse(
              associationRaw['modifiedDate'] ?? DateTime(1).toString()),
          uaid: -1, // TODO 참고
        ),
      );
    }
    return null;
  }
}
