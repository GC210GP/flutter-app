import 'dart:async';

import 'package:app/util/chat/chat_data.dart';
import 'package:app/util/network/fire_chat_service.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageView extends StatefulWidget {
  const MessageView({
    Key? key,
    this.chatroomId,
    required this.toName,
    required this.fromId,
    required this.toId,
  }) : super(key: key);

  final String toName;
  final String? chatroomId;

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

  @override
  void initState() {
    super.initState();

    fireChatService = FireChatService(onChanged: (data) async {
      chatBubbles.clear();

      for (ChatMessage i in data) {
        chatBubbles.add(
          ChatBubble(msg: i.msg, isLeft: i.senderId != GlobalVariables.userIdx),
        );
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
        title: widget.toName,
        actions: [
          Center(
            child: DDButton(
              label: "헌혈방법",
              height: 30,
              width: 80,
              margin: const EdgeInsets.only(right: 20.0),
              fontColor: DDColor.white,
              color: DDColor.grey.withOpacity(0.5),
              fontWeight: DDFontWeight.bold,
              fontSize: DDFontSize.h4,
              onPressed: () => {},
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
                            color: controller.text.isNotEmpty
                                ? DDColor.primary
                                : DDColor.disabled,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            borderRadius:
                                BorderRadius.circular(GlobalVariables.radius),
                            child: const Icon(CupertinoIcons.paperplane_fill,
                                size: 20),
                            onPressed: () {
                              fireChatService.sendMessage(
                                message: controller.text,
                              );
                              controller.text = "";
                            }),
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
}

///
///
///
///
///
class ChatBubble extends StatelessWidget {
  final String msg;
  final bool isLeft;

  const ChatBubble({
    Key? key,
    required this.msg,
    required this.isLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
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
                msg,
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
      ],
    );
  }
}
