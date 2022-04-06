import 'package:app/util/theme/colors.dart';
import 'package:app/util/network/fire_control.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/message_view.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePageView extends StatefulWidget {
  const MessagePageView({Key? key}) : super(key: key);

  @override
  _MessagePageViewState createState() => _MessagePageViewState();
}

class _MessagePageViewState extends State<MessagePageView> {
  List<Widget> chatroomList = [];
  late FireControl _fireControl;
  double pageOpacity = 0;
  bool isListLoaded = false;

  @override
  void initState() {
    super.initState();

    ///
    /// TODO: 추후 상태관리로 이동
    assert(FireControl.instance != null, "FireControl was not initialized!");
    if (FireControl.instance != null) {
      _fireControl = FireControl.instance!;
    }

    listLoader().then((_) {
      pageOpacity = 1.0;
      isListLoaded = true;
      setState(() {});
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
            if (isListLoaded)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PageTitleWidget(title: "메시지"),
                    Expanded(
                      child: chatroomList.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(GlobalVariables.radius),
                                topRight:
                                    Radius.circular(GlobalVariables.radius),
                              ),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        GlobalVariables.radius),
                                    child: Column(
                                      children: [...chatroomList],
                                    ),
                                  )
                                ],
                              ),
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
                                    "\n대화가 없습니다\n[홈]이나 [커뮤니티] 탭에서 대화를 시작해보세요\n\n\n\n",
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
    var value = await _fireControl.getDocList();

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
          ChatroomItem(
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
}

class ChatroomItem extends StatelessWidget {
  final String imgSrc;
  final String name;
  final String lastMsg;
  final VoidCallback? onPressed;

  const ChatroomItem({
    Key? key,
    required this.imgSrc,
    required this.name,
    this.lastMsg = "",
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: DDColor.widgetBackgroud,
          border: Border(
            bottom: BorderSide(
              color: DDColor.background,
            ),
          ),
        ),
        child: CupertinoButton(
          padding: const EdgeInsets.all(.0),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    imgSrc,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: DDFontFamily.nanumSR,
                          fontWeight: DDFontWeight.bold,
                          fontSize: DDFontSize.h4,
                          color: DDColor.fontColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lastMsg,
                        style: TextStyle(
                          fontFamily: DDFontFamily.nanumSR,
                          fontWeight: DDFontWeight.bold,
                          fontSize: DDFontSize.h5,
                          color: DDColor.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
