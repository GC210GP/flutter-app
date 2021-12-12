import 'dart:async';
import 'dart:convert';

import 'package:blood_donation/util/chat/chat_data.dart';
import 'package:blood_donation/util/fire_control.dart';
import 'package:blood_donation/util/global_variables.dart';
import 'package:blood_donation/widget/input_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageView extends StatefulWidget {
  const MessageView({
    Key? key,
    this.chatroomId,
    required this.fromName,
    required this.fromId,
    required this.toId,
  }) : super(key: key);

  final String fromName;
  final String? chatroomId;

  final int fromId;
  final int toId;

  @override
  _MessageViewState createState() => _MessageViewState();
}

late StreamSubscription<DocumentSnapshot<Object?>> listener;

class _MessageViewState extends State<MessageView> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  FireControl fireControl = FireControl(collectionName: "chat");
  late DocumentReference<Object?> document;
  late Stream<DocumentSnapshot<Object?>> stream;
  late ChatData chatdata;

  String? genChatroomId;
  List<Widget> chatBubbles = [];

  @override
  void initState() {
    super.initState();
    // fireControl.init();

    fireControl.init().then((value) {
      CollectionReference<Object?> collection = fireControl.collection;

      fireControl.getDocList().then((value) {
        if (widget.chatroomId == null) {
          String str1 = widget.fromId.toString() + "-" + widget.toId.toString();
          String str2 = widget.toId.toString() + "-" + widget.fromId.toString();
          bool isChatroomCreated = false;
          genChatroomId = str1;

          if (value.contains(str1)) {
            isChatroomCreated = true;
          } else if (value.contains(str2)) {
            isChatroomCreated = true;
            genChatroomId = str2;
          }

          print("====================");
          print(isChatroomCreated);
          print(genChatroomId);

          if (!isChatroomCreated) {
            collection.doc(genChatroomId).set(
              {
                '"metadata"': {
                  '"member"': [widget.fromId, widget.toId],
                  '"isDone"': false,
                },
                '"content"': [
                  // {
                  //   '"timestamp"': '"${DateTime.now().toLocal().toString()}"',
                  //   '"msg"': '"안녕하세요!"',
                  //   '"senderId"': 2,
                  // },
                ],
              },
            );
          }
        } else {
          genChatroomId = widget.chatroomId;
        }

        document = collection.doc(genChatroomId);
        stream = document.snapshots();

        listener = stream.listen(streamListener);
      });
    });
  }

  streamListener(event) {
    chatdata = ChatData(event.data().toString());
    chatBubbles.clear();

    for (ChatMessage i in chatdata.content) {
      chatBubbles.add(
        bubbleBody(msg: i.msg, isLeft: i.senderId != GlobalVariables.userIdx),
      );
    }

    if (scrollController.offset == 0.0) {
      Future.delayed(Duration(milliseconds: 0)).then((_) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      });
    } else {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 45,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    setState(() {});
  }

  sendMessage({required String message}) {
    chatdata.content.add(ChatMessage(
        senderId: GlobalVariables.userIdx,
        timestamp: DateTime.now(),
        msg: message));
    document.update(chatdata.toFireStore());
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            CupertinoIcons.chevron_back,
                            size: 25,
                            color: Colors.grey,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          widget.fromName,
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
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
              height: controller.value.selection.baseOffset == -1 ? 100 : 55,
              decoration: BoxDecoration(
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
                          child: Container(
                            height: 40,
                            child: InputBox(
                              controller: controller,
                              onChanged: (_) {
                                setState(() {});
                              },
                              onTap: () {
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent +
                                      270,
                                  duration: Duration(milliseconds: 150),
                                  curve: Curves.easeOut,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 40,
                          width: 55,
                          child: CupertinoButton(
                            color: controller.text.length > 0
                                ? Colors.red.shade300
                                : Colors.grey.shade300,
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            borderRadius: BorderRadius.circular(15),
                            child:
                                Icon(CupertinoIcons.paperplane_fill, size: 20),
                            onPressed: () {
                              sendMessage(message: controller.text);
                            },
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
      ),
    );
  }

  Widget bubbleBody({required String msg, required bool isLeft}) => Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                color: isLeft ? Colors.white : Colors.red.shade300,
                borderRadius: BorderRadius.circular(15),
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
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  msg,
                  style: TextStyle(
                    fontFamily: "NanumSR",
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: isLeft ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
