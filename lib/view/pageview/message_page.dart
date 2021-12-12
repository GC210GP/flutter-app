import 'package:blood_donation/util/fire_control.dart';
import 'package:blood_donation/util/global_variables.dart';
import 'package:blood_donation/view/message_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MessagePageView extends StatefulWidget {
  const MessagePageView({Key? key}) : super(key: key);

  @override
  _MessagePageViewState createState() => _MessagePageViewState();
}

class _MessagePageViewState extends State<MessagePageView> {
  List<Widget> chatroomList = [];
  FireControl fireControl = FireControl(collectionName: "chat");
  double pageOpacity = 0;

  @override
  void initState() {
    super.initState();

    fireControl.init().then((value) {
      pageOpacity = 1;
      listLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "메시지",
                    style: TextStyle(
                      fontFamily: "NanumSR",
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [...chatroomList],
                ),
              )
            ],
          ),
        ),
      ),
      opacity: pageOpacity,
      duration: Duration(milliseconds: 100),
    );
  }

  Future<void> listLoader() async {
    var value = await fireControl.getDocList();
    // http
    //     .get(Uri.parse(GlobalVariables.baseurl + "/users?userId=9"))
    //     .then((value) {
    //   print(convert.utf8.decode(value.bodyBytes));
    // });

    for (String i in value) {
      List<String> list = i.split("-");
      if (list.contains(GlobalVariables.userIdx.toString())) {
        int toId = -1;

        if (list[0] == GlobalVariables.userIdx.toString()) {
          toId = int.parse(list[1]);
        } else {
          toId = int.parse(list[0]);
        }

        // TODO: toID 값 가져와서 채팅룸 생성하기

        chatroomList.add(
          chatroomItem(
            imgSrc:
                "https://sw.gachon.ac.kr/files/GA1/cms/attach/2/5c65d9c885649cf21365e270bc1a8bc7.jpg",
            name: toId.toString(),
            // lastMsg: "안녕하세요.",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessageView(
                  chatroomId: i,
                  fromId: GlobalVariables.userIdx,
                  toId: toId,
                  fromName: "nickname($toId)",
                ),
              ),
            ),
          ),
        );
      }
    }

    setState(() {});
  }

  Widget chatroomItem({
    required String imgSrc,
    required String name,
    String lastMsg = "",
    VoidCallback? onPressed,
  }) =>
      CupertinoButton(
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  imgSrc,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: "NanumSR",
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    if (lastMsg.length != 0) SizedBox(height: 5),
                    if (lastMsg.length != 0)
                      Text(
                        lastMsg,
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
