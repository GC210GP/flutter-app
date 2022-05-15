import 'dart:async';

import 'package:app/model/fcm.dto.dart';
import 'package:app/util/chat/chat_data.dart';
import 'package:app/util/network/fire_chat_service.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/util/time_print.dart';
import 'package:app/view/user_profile_view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import 'package:http/http.dart' as http;

class MessageView extends StatefulWidget {
  const MessageView({
    Key? key,
    // this.chatroomId,
    // required this.toName,
    required this.fromId,
    required this.toId,
  }) : super(key: key);

  // final String toName;
  // final String? chatroomId;

  final int fromId;
  final int toId;

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  late FireChatService fireChatService;
  List<Widget> chatBubbles = [];

  String toName = "알 수 없음";
  String toToken = "";
  String toImgSrc = GlobalVariables.defaultImgUrl;

  @override
  void initState() {
    super.initState();

    fireChatService = FireChatService(onChanged: (data) async {
      chatBubbles.clear();

      for (ChatMessage i in data) {
        chatBubbles.add(
          ChatBubble(
            msg: i.msg,
            time: i.timestamp,
            isLeft: i.senderId != GlobalVariables.userDto!.uid,
          ),
        );
      }

      Map<String, dynamic> result = await GlobalVariables.httpConn.get(
        apiUrl: "/users",
        queryString: {"userId": widget.toId},
      );

      if (result['httpConnStatus'] == httpConnStatus.success) {
        toName = result['data']['nickname'] ?? "알 수 없음";
        toToken = result['data']['fbToken'] ?? "";
        toImgSrc = result['data']['profileImageLocation'] ??
            GlobalVariables.defaultImgUrl;
      }

      setState(() {});

      await Future.delayed(const Duration(milliseconds: 150));

      if (scrollController.offset >=
          scrollController.position.maxScrollExtent - 50.0) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } else if (scrollController.offset != 0.0) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 43,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      } else {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    fireChatService.initChatroom(
      fromId: widget.fromId,
      toId: widget.toId,
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    fireChatService.terminateListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DDColor.background,
      appBar: DDAppBar(
        context,
        title: toName,
        actions: [
          CupertinoButton(
            borderRadius: BorderRadius.circular(30),
            padding: const EdgeInsets.all(0.0),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileView(
                  title: "메시지",
                  toId: widget.toId,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                toImgSrc,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: DDButton(
              label: "헌혈방법",
              height: 30,
              width: 80,
              margin: const EdgeInsets.only(right: 20.0),
              fontColor: DDColor.white,
              color: DDColor.grey,
              fontWeight: DDFontWeight.bold,
              fontSize: DDFontSize.h4,
              onPressed: () => url.launch(
                "https://biss.bloodinfo.net/direct_donation_hos.jsp",
                forceWebView: true,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: 0.5,
            thickness: 0.5,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      children: [...chatBubbles],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: focusNode.hasFocus ? 55 : 90,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  offset: Offset(0, 2),
                  spreadRadius: 0.0,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: DDTextField(
                            focusNode: focusNode,
                            elevation: 0.0,
                            backgroundColor: DDColor.background,
                            controller: controller,
                            onChanged: (_) => setState(() {}),
                            onTap: () async {
                              setState(() {});
                              await Future.delayed(
                                  const Duration(milliseconds: 450));
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              );
                            },
                            onFieldSubmitted: (_) => setState(() {}),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        height: 40,
                        width: 55,
                        child: CupertinoButton(
                          color: DDColor.primary,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          borderRadius:
                              BorderRadius.circular(GlobalVariables.radius),
                          child: const Icon(CupertinoIcons.paperplane_fill,
                              size: 20),
                          onPressed:
                              controller.text.isNotEmpty ? sendMessage : null,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    String msg = controller.text.trim();

    // 빈 메시지 발송 방지
    if (msg.isEmpty) {
      controller.text = "";
      setState(() {});
      return;
    }

    fireChatService.sendMessage(
      message: controller.text,
    );

    GlobalVariables.httpConn.fbPost(
      sendData: FcmDto(
        token: toToken,
        title: GlobalVariables.userDto!.nickname,
        body: controller.text,
        data: {
          "toId": widget.fromId,
          "fromId": widget.toId,
          "toName": GlobalVariables.userDto!.nickname,
        },
      ),
    );
    controller.text = "";
    setState(() {});
  }
}

///
///
///
///
///
class ChatBubble extends StatelessWidget {
  final String msg;
  final bool isLeft;
  final DateTime time;

  const ChatBubble({
    Key? key,
    required this.msg,
    required this.isLeft,
    required this.time,
  }) : super(key: key);

  String changeStringToBubble(String input) {
    String result = "";

    for (int i = 0; i < input.length; i++) {
      result += input[i];
      if (i >= 15 && i % 15 == 0) {
        result += "\n";
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isLeft)
          Container(
            margin: const EdgeInsets.only(bottom: 10.0, right: 3.0),
            child: Text(
              TimePrint.msgFormat(time),
              style: TextStyle(
                fontFamily: DDFontFamily.nanumSR,
                fontWeight: DDFontWeight.bold,
                fontSize: DDFontSize.msgtime,
                color: DDColor.grey,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              color: isLeft ? DDColor.widgetBackgroud : DDColor.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  offset: Offset(0, 2),
                  spreadRadius: 0.0,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                changeStringToBubble(msg),
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.bold,
                  fontSize: DDFontSize.h4,
                  color: isLeft ? Colors.grey.shade800 : Colors.grey.shade100,
                ),
              ),
            ),
          ),
        ),
        if (isLeft)
          Container(
            margin: const EdgeInsets.only(bottom: 10.0, left: 3.0),
            child: Text(
              TimePrint.msgFormat(time),
              style: TextStyle(
                fontFamily: DDFontFamily.nanumSR,
                fontWeight: DDFontWeight.bold,
                fontSize: DDFontSize.msgtime,
                color: DDColor.disabled,
              ),
            ),
          ),
      ],
    );
  }
}
