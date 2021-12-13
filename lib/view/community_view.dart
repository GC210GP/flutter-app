import 'package:blood_donation/view/community_board_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  _CommunityViewState createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "#성남시",
                    style: TextStyle(
                      fontFamily: "NanumSR",
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        item(author: "성남주민", title: "성남병원 지정헌혈 부탁드립니다.."),
                        item(author: "분당주민", title: "지금 제생병원에 있습니다. 정말 급합니다!"),
                        item(author: "이매주민", title: "서울대병원 지정헌혈 부탁드립니다.."),
                        CupertinoButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommunityBoardView(),
                            ),
                          ),
                          child: SizedBox(
                            width: 1000,
                            child:
                                item(author: "테평주민", title: "제 친구가 많이 아파요..ㅠ"),
                          ),
                        ),
                        item(author: "위례주민", title: "분당제생병원 지정헌혈 부탁드립니다.."),
                        item(author: "정자주민", title: "저희 가족을 도와주세요"),
                      ],
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

  Widget item({required String author, required String title}) => Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author,
                style: TextStyle(
                  fontFamily: "NanumSR",
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontFamily: "NanumSR",
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
        ),
      );
}
