import 'package:app/model/person.dto.dart';
import 'package:app/util/colors.dart';
import 'package:app/util/fire_control.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/view/message_view.dart';
import 'package:app/widget/page_title_widget.dart';
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
  bool isFireControlLoaded = false;

  @override
  void initState() {
    super.initState();
    fireControl.init().then((isSuccess) async {
      pageOpacity = 1;
      setState(() {});

      if (isSuccess) {
        await Future.delayed(const Duration(milliseconds: 250));
        await listLoader();
        isFireControlLoaded = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isFireControlLoaded)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PageTitleWidget(title: "메시지"),
                    Expanded(
                      child: chatroomList.isNotEmpty
                          ? ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [...chatroomList],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "💬",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "NanumSR",
                                      fontSize: 50,
                                    ),
                                  ),
                                  Text(
                                    "\n대화가 없습니다\n'홈'이나 '추천' 탭에서 대화를 시작해보세요\n\n\n\n",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "NanumSR",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              )

            ///
            ///
            ///
            // FireControl 비정상 로드
            else
              Center(
                child: Container(
                  width: 50,
                  height: 100,
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 7.5,
                    color: DDColor.primary.shade600,
                    backgroundColor: DDColor.disabled,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> listLoader() async {
    var value = await fireControl.getDocList();
    // http
    //     .get(Uri.parse(GlobalVariables.baseurl + "/users?userId=9"))
    //     .then((value) {
    //   print(convert.utf8.decode(value.bodyBytes));
    // });
    print(value);
    print(GlobalVariables.userIdx);

    for (String i in value) {
      List<String> list = i.split("=");
      if (list.contains(GlobalVariables.userIdx.toString())) {
        int toId = -1;

        if (list[0] == GlobalVariables.userIdx.toString()) {
          toId = int.parse(list[1]);
        } else {
          toId = int.parse(list[0]);
        }

        chatroomList.add(
          chatroomItem(
            imgSrc:
                "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
            name: toId.toString(),
            lastMsg:
                GlobalVariables.userIdx.toString() + "->" + toId.toString(),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessageView(
                  chatroomId: i,
                  fromId: GlobalVariables.userIdx,
                  toId: toId,
                  toName: toId.toString(),
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  Widget chatroomItem({
    required String imgSrc,
    required String name,
    String lastMsg = "",
    VoidCallback? onPressed,
  }) =>
      CupertinoButton(
        padding: const EdgeInsets.all(0),
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
