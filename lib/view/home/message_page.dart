import 'package:app/util/network/fire_chat_service.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/network/fire_control.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/util/time_print.dart';
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
                                      fontFamily: DDFontFamily.nanumSR,
                                      fontWeight: DDFontWeight.extraBold,
                                      fontSize: DDFontSize.h4,
                                      color: DDColor.grey,
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

    setState(() {
      chatroomList.clear();
      isListLoaded = false;
    });

    // 로그인 안되어있을 시,
    if (GlobalVariables.userDto == null) return;

    List<List<String>> targetChatroomLists = [];
    List<ChatroomItemDto> chatroomItemDtos = [];

    int totalCount = 0;
    int doneCount = 0;

    for (String i in value) {
      List<String> list = i.split("=");
      if (list.contains(GlobalVariables.userDto!.uid.toString())) {
        targetChatroomLists.add(list);
        totalCount++;
      }
    }

    for (List<String> list in targetChatroomLists) {
      int toId = -1;
      String userNickname = "알 수 없음";
      String lastChat = "알 수 없음";
      DateTime lastChatTime = GlobalVariables.defaultDateTime;
      bool isRecent = false;

      if (list[0] == GlobalVariables.userDto!.uid.toString()) {
        toId = int.parse(list[1]);
      } else {
        toId = int.parse(list[0]);
      }

      ///
      ///
      ///
      ///
      ///

      FireChatService fireChatService = FireChatService();
      fireChatService.initChatroom(
        fromId: GlobalVariables.userDto!.uid,
        toId: toId,
      );
      fireChatService = FireChatService(onChanged: (data) async {
        lastChat = data.last.msg;
        lastChatTime = data.last.timestamp;
        isRecent = data.last.senderId != GlobalVariables.userDto!.uid;

        chatroomItemDtos.add(ChatroomItemDto(
          chatroomId: "${list[0]}=${list[1]}",
          userNickname: userNickname,
          lastChat: lastChat,
          lastChatTime: lastChatTime,
          isRecent: isRecent,
          toId: toId,
        ));

        doneCount++;
      });

      await fireChatService.initChatroom(
        fromId: GlobalVariables.userDto!.uid,
        toId: toId,
      );
    }

    int timeoutCount = 0;
    while (true) {
      if (doneCount >= totalCount) break;
      if (timeoutCount >= 5000) break; // 시간초과
      await Future.delayed(const Duration(milliseconds: 100));
      timeoutCount += 100;
    }

    // 채팅방 정렬
    chatroomItemDtos.sort(((a, b) => b.lastChatTime.compareTo(a.lastChatTime)));

    ///
    ///
    ///

    for (ChatroomItemDto item in chatroomItemDtos) {
      Map<String, dynamic> result =
          await GlobalVariables.httpConn.get(apiUrl: "/users", queryString: {
        "userId": item.toId,
      });

      if (result['httpConnStatus'] == httpConnStatus.success) {
        item.userNickname = result['data']['nickname'];
      }

      chatroomList.add(
        ChatroomItem(
          imgSrc: result['data']['profileImageLocation'],
          name: item.userNickname,
          lastMsg: item.lastChat,
          lastMsgTime: item.lastChatTime,
          isRecent: item.isRecent,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MessageView(
                fromId: GlobalVariables.userDto!.uid,
                toId: item.toId,
              ),
            ),
          ).then(
            (value) => listLoader(),
          ),
        ),
      );
    }

    setState(() {
      isListLoaded = true;
    });
  }
}

class ChatroomItemDto {
  int toId;
  String userNickname;
  String lastChat;
  DateTime lastChatTime;
  bool isRecent;
  String chatroomId;
  ChatroomItemDto({
    required this.chatroomId,
    required this.lastChatTime,
    this.userNickname = "알 수 없음",
    this.lastChat = "알 수 없음",
    this.isRecent = false,
    this.toId = -1,
  });
}

class ChatroomItem extends StatelessWidget {
  final String imgSrc;
  final String name;
  final String lastMsg;
  final VoidCallback? onPressed;
  final bool isRecent;
  final DateTime lastMsgTime;

  const ChatroomItem({
    Key? key,
    required this.imgSrc,
    required this.name,
    required this.lastMsgTime,
    this.lastMsg = "",
    this.onPressed,
    this.isRecent = false,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontFamily: DDFontFamily.nanumSR,
                                fontWeight: DDFontWeight.bold,
                                fontSize: DDFontSize.h4,
                                color: DDColor.fontColor,
                              ),
                            ),
                          ),
                          if (isRecent)
                            Container(
                              margin: const EdgeInsets.only(right: 5.0),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: DDColor.primary,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2.0,
                                    offset: const Offset(.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMsg.length > 30
                                  ? lastMsg.substring(0, 30) + "..."
                                  : lastMsg,
                              style: TextStyle(
                                fontFamily: DDFontFamily.nanumSR,
                                fontWeight: DDFontWeight.bold,
                                fontSize: DDFontSize.h5,
                                color: DDColor.grey,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              TimePrint.format(lastMsgTime),
                              style: TextStyle(
                                fontFamily: DDFontFamily.nanumSR,
                                fontWeight: DDFontWeight.bold,
                                fontSize: DDFontSize.h6,
                                color: DDColor.grey,
                              ),
                            ),
                          ),
                        ],
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
