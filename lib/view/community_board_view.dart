import 'package:blood_donation/util/colors.dart';
import 'package:blood_donation/util/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_view.dart';

class CommunityBoardView extends StatefulWidget {
  const CommunityBoardView({Key? key}) : super(key: key);

  @override
  _CommunityBoardViewState createState() => _CommunityBoardViewState();
}

class _CommunityBoardViewState extends State<CommunityBoardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DDColor.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Text(
            //       "커뮤니티",
            //       style: TextStyle(
            //         fontFamily: "NanumSR",
            //         fontWeight: FontWeight.w900,
            //         fontSize: 30,
            //         color: Colors.grey.shade800,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    "제 친구가 많이 아파요..ㅠ",
                    style: TextStyle(
                      fontFamily: "NanumSR",
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "테평주민",
                    style: TextStyle(
                      fontFamily: "NanumSR",
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 35),
                  Text(
                    "안녕하세요.. 지금 태평에 살고 있는데 친구가 서울대병원에 입원중입니다. \n\n친구가 혈액암으로 투병중인데 요즘 코로나라 헌혈을 받기가 너무 힘들다고 하네요.. \n\n혹시 현혈이 가능하시다면 연락바랍니다!",
                    style: TextStyle(
                      fontFamily: "NanumSR",
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 2000,
              height: 60,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(15),
                child: Text(
                  "도와주기",
                  style: TextStyle(
                    fontFamily: "NanumSR",
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.grey.shade100,
                  ),
                ),
                color: Colors.red.shade300,
                padding: EdgeInsets.all(0),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MessageView(
                      fromId: GlobalVariables.userIdx,
                      toId: 4,
                      toName: "태평주민",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
