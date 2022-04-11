import 'package:app/model/post.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/home/home_view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

class CommunityEditorView extends StatefulWidget {
  final PostDto post;

  const CommunityEditorView({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _CommunityEditorViewState createState() => _CommunityEditorViewState();
}

class _CommunityEditorViewState extends State<CommunityEditorView> {
  bool isModify = false;
  FocusNode focusNodeTitle = FocusNode();
  FocusNode focusNodeContent = FocusNode();

  late String title;
  late String content;

  @override
  void initState() {
    title = widget.post.title;
    content = widget.post.content;

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
      appBar: DDAppBar(context, title: "뒤로", onBackPressed: () async {
        //  글에 아무 내용 없을 시 삭제
        await deletePost(widget.post.pid);
        Navigator.pop(context);
      }),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                const PageTitleWidget(title: "글쓰기"),
                Positioned(
                  top: .0,
                  right: .0,
                  child: Center(
                    child: DDButton(
                      child: Icon(Icons.delete_forever_rounded),
                      color: DDColor.grey.withOpacity(0.5),
                      height: 35.0,
                      width: 35.0,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: const Text("글을 삭제하시겠습니까?"),
                          actions: [
                            CupertinoButton(
                              child: Text(
                                "예",
                                style: TextStyle(color: DDColor.primary),
                              ),
                              onPressed: () => deletePost(widget.post.pid),
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
                ),
              ],
            ),
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
              labelText: title,
              onChanged: (value) => title = value,
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
                labelText: content,
                onChanged: (value) => content = value,
              ),
            ),

            const SizedBox(height: 5.0),
            if (!focusNodeContent.hasFocus && !focusNodeTitle.hasFocus)
              Stack(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "[도움말]\n* 게시글 작성 시, 모든 커뮤니티에 한꺼번에 등록됩니다.\n\n",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h6,
                            color: DDColor.grey,
                          ),
                        ),
                        TextSpan(
                          text:
                              "[게시글 작성 Tip!]\n1. 수혈이 필요한 환자분의 혈액형을 정확히 명시해주세요.\n2. 필요하신 혈액제제를 입력해주세요.\n3. 자세한 내용은 ",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h6,
                            color: DDColor.grey,
                          ),
                        ),
                        const TextSpan(
                          text: "[안내 홈페이지]",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h6,
                            color: Colors.blueAccent,
                          ),
                        ),
                        TextSpan(
                          text:
                              "를 참고해주세요.\n4. 개인정보를 유추할 수 있는 전화번호, 주소 등은 입력하지 말아주세요.\n",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h6,
                            color: DDColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 70,
                    child: CupertinoButton(
                      child: const SizedBox(
                        width: 78,
                        height: 15,
                      ),
                      onPressed: () => url.launch(
                        "https://biss.bloodinfo.net/direct_donation_hos.jsp",
                        forceWebView: true,
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 10.0),
            if (!focusNodeContent.hasFocus && !focusNodeTitle.hasFocus)
              DDButton(
                label: isModify ? "수정하기" : "등록하기",
                onPressed: () {
                  commitBoard(
                    content: content,
                    title: title,
                    postId: widget.post.pid,
                  );
                },
              )
            else
              DDButton(
                  label: "수정완료",
                  color: DDColor.grey,
                  onPressed: () {
                    focusNodeTitle.unfocus();
                    focusNodeContent.unfocus();
                  }),
            if (!focusNodeContent.hasFocus && !focusNodeTitle.hasFocus)
              const SizedBox(height: 50.0)
            else
              const SizedBox(height: 10.0)
          ],
        ),
      ),
    );
  }

  Future<void> commitBoard(
      {required String title,
      required String content,
      required int postId}) async {
    Map<String, dynamic> result =
        await GlobalVariables.httpConn.patch(apiUrl: "/posts/$postId", body: {
      "title": title.isEmpty ? "[빈 제목]" : title,
      "content": content.isEmpty ? "내용 없음." : content,
    });
    debugPrint(result.toString());
    if (result['httpConnStatus'] == httpConnStatus.success) {
      debugPrint("${result.toString()} / postId: $postId");
      Navigator.pop(context);
    }
  }

  Future<void> deletePost(int pid) async {
    Map<String, dynamic> result =
        await GlobalVariables.httpConn.delete(apiUrl: "/posts/$pid");

    if (result['httpConnStatus'] == httpConnStatus.success) {
      Navigator.pop(context);
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeView(
            index: 3,
          ),
        ),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }
}
