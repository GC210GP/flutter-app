import 'dart:io';

import 'package:app/model/fcm.dto.dart';
import 'package:app/model/person.dto.dart';
import 'package:app/util/secret.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/view/community/community_editor_view.dart';
import 'package:app/widget/button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as url;
import '../message_view.dart';

class SuggestionPageView extends StatefulWidget {
  const SuggestionPageView({Key? key}) : super(key: key);

  @override
  _SuggestionPageViewState createState() => _SuggestionPageViewState();
}

class _SuggestionPageViewState extends State<SuggestionPageView> {
  CarouselController controller = CarouselController();

  double pageOpacity = 0;
  HttpConn httpConn = HttpConn();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      pageOpacity = 1;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: Column(
        children: [
          const SuggestionUpperBar(),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Builder(
                builder: (context) {
                  List<Widget> caroselList = [];

                  for (UserDto user in GlobalVariables.suggestionList) {
                    caroselList.add(
                      CaroselItemLayout(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ///
                                  ///
                                  ///
                                  ///
                                  ///

                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: DDColor.background,
                                      borderRadius: BorderRadius.circular(140),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.2),
                                          offset: Offset(0, 4),
                                          spreadRadius: 0.0,
                                          blurRadius: 7.0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(130),
                                          child: Image.network(
                                            user.profileImageLocation,
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///
                                  ///
                                  ///
                                  ///
                                  ///

                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        user.nickname,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "NanumSR",
                                          fontWeight: FontWeight.w900,
                                          fontSize: 23,
                                          color: Colors.red.shade300,
                                        ),
                                      ),
                                      Text(
                                        " 님은",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "NanumSR",
                                          fontWeight: FontWeight.w900,
                                          fontSize: 23,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "당신의 도움이 필요해요",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "NanumSR",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  ///
                                  ///
                                  ///
                                  ///
                                  ///

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///

                                      ShadowBox(
                                        height: 35,
                                        color: Colors.red.shade300,
                                        width:
                                            user.bloodType.toString().length *
                                                13.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "   " +
                                              user.bloodType.toString() +
                                              "   ",
                                          style: TextStyle(
                                            fontFamily: "NanumSR",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ),

                                      ///
                                      ///
                                      ///
                                      ///
                                      ///

                                      SizedBox(width: 5),
                                      CupertinoButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () => url.launch(
                                            "https://instagram.com/${user.sns[0].snsProfile.substring(1, user.sns[0].snsProfile.length)}"),
                                        child: ShadowBox(
                                          height: 35,
                                          color: Colors.purple.shade300,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "   " +
                                                user.sns[0].snsProfile +
                                                "   ",
                                            style: TextStyle(
                                              fontFamily: "NanumSR",
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15,
                                              color: Colors.grey.shade100,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),

                                      ///
                                      ///
                                      ///
                                      ///
                                      ///

                                      ShadowBox(
                                        height: 35,
                                        color: Colors.pink.shade300,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "   " + user.location + "   ",
                                          style: TextStyle(
                                            fontFamily: "NanumSR",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            ///
                            ///
                            ///
                            ///
                            ///

                            Expanded(
                              flex: 10,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: ShadowBox(
                                          height: 75,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.thermostat_sharp,
                                                color: Colors.red.shade300,
                                                size: 40,
                                              ),
                                              SizedBox(width: 7),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "나와의 온도",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: "NanumSR",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                  Text(
                                                    // TODO: Correlation 값
                                                    (0.23 * 100).toString() +
                                                        "℃",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: "NanumSR",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 22,
                                                      color:
                                                          Colors.red.shade300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      ///
                                      ///
                                      ///
                                      ///
                                      ///
                                      ///

                                      // SizedBox(
                                      //   width: 15,
                                      // ),
                                      // Expanded(
                                      //   child: shadowBox(
                                      //     alignment: Alignment.center,
                                      //     height: 75,
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Icon(
                                      //           CupertinoIcons.person_2_fill,
                                      //           color: Colors.red.shade300,
                                      //           size: 30,
                                      //         ),
                                      //         SizedBox(width: 7),
                                      //         Column(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.center,
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.start,
                                      //           children: [
                                      //             Text(
                                      //               "연결고리",
                                      //               textAlign: TextAlign.center,
                                      //               style: TextStyle(
                                      //                 fontFamily: "NanumSR",
                                      //                 fontWeight:
                                      //                     FontWeight.w900,
                                      //                 fontSize: 11,
                                      //                 color:
                                      //                     Colors.grey.shade500,
                                      //               ),
                                      //             ),
                                      //             Text(
                                      //               i["rels"][0] +
                                      //                   ", " +
                                      //                   i["rels"][1] +
                                      //                   "..",
                                      //               textAlign: TextAlign.center,
                                      //               style: TextStyle(
                                      //                 fontFamily: "NanumSR",
                                      //                 fontWeight:
                                      //                     FontWeight.w900,
                                      //                 fontSize: 13,
                                      //                 color:
                                      //                     Colors.red.shade300,
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),

                                  ///
                                  ///
                                  ///
                                  ///
                                  ///

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: CupertinoButton(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      GlobalVariables.radius),
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
                                                    fromId:
                                                        GlobalVariables.userIdx,
                                                    // TODO: 연락할 상대방 정보 입력
                                                    toId: user.uid,
                                                    toName: user.nickname,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          SizedBox(
                                            width: 75,
                                            child: CupertinoButton(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      GlobalVariables.radius),
                                              child: Icon(
                                                  CupertinoIcons.star_fill),
                                              color: Colors.pinkAccent.shade400,
                                              padding: EdgeInsets.all(0),
                                              onPressed: () => {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  ///
                                  ///
                                  ///
                                  ///
                                  ///
                                  ///
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  ///
                  ///
                  ///
                  ///
                  ///
                  // 리스트에 아무도 없을 경우

                  if (GlobalVariables.suggestionList.length == 0) {
                    caroselList.add(
                      CaroselItemLayout(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "로그인하시면\n도움이 필요한\n친구들을 찾아드립니다",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "NanumSR",
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            SizedBox(height: 20),
                            DDButton(
                              label: "로그인",
                              width: 100,
                              onPressed: () {
                                Navigator.pushNamed(context, "/signin");
                              },
                            ),
                            SizedBox(height: 20),
                            DDButton(
                              label: "Auth",
                              width: 100,
                              onPressed: () async {
                                dynamic result = await httpConn.auth(
                                    email: 'a016232@daum.com',
                                    password: '1234');
                                print(result);
                              },
                            ),
                            DDButton(
                              label: "Get",
                              width: 100,
                              onPressed: () async {
                                dynamic result = await httpConn.get(
                                  apiUrl: "/users",
                                  queryString: {
                                    "userId": 10,
                                  },
                                );
                                print(result);
                              },
                            ),
                            DDButton(
                              label: "POST",
                              width: 100,
                              onPressed: () {},
                            ),
                            DDButton(
                              label: "PATCH",
                              width: 100,
                              onPressed: () {},
                            ),
                            DDButton(
                              label: "DELETE",
                              width: 100,
                              onPressed: () {},
                            ),
                            DDButton(
                              label: "FCM",
                              width: 100,
                              onPressed: () {
                                HttpConn().fbPost(
                                  sendData: FcmDto(
                                    token: Secret.testTarget,
                                    title: "테스트",
                                    body: "테스트입니다.",
                                    data: {
                                      "fromId": 4,
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return CarouselSlider(
                    carouselController: controller,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      aspectRatio: 1 / 2,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        print("index: $index / reason: $reason");
                      },
                      onScrolled: (value) {
                        print("value: $value");
                      },
                    ),
                    items: caroselList,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> getSuggestion() async {
    for (int i = 0; i < 10; i++) {
      GlobalVariables.suggestionList.add(
        UserDto(
          uid: 1,
          name: "홍길동",
          nickname: "홍홍",
          email: "tttt@test.com",
          sns: [SnsDto(snsType: SnsType.INSTAGRAM, snsProfile: "doky.sp")],
          phoneNumber: "010-4444-7777",
          profileImageLocation:
              "https://www.pcmag.com/images/PCMag_NavLogo.png",
          birthdate: DateTime.now(),
          location: "경기도 성남시 수정구",
          sex: Gender.MALE,
          job: "학생",
          bloodType: BloodType.PLUS_A,
          isDormant: false,
          isDonated: false,
          createdDate: DateTime.now(),
          updatedDate: DateTime.now(),
        ),
      );
    }

    setState(() {});
  }
}

///
///
///
///
///

class CaroselItemLayout extends StatelessWidget {
  final Widget child;
  const CaroselItemLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowBox(child: child),
          ),
        ),
      ],
    );
  }
}

///
///
///
///
///

class ShadowBox extends StatelessWidget {
  final Alignment? alignment;
  final double? width;
  final double? height;
  final Color? color;
  final Widget child;

  const ShadowBox({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.alignment,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? DDColor.white,
        borderRadius: BorderRadius.circular(GlobalVariables.radius),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 4),
            spreadRadius: 0.0,
            blurRadius: 7.0,
          ),
        ],
      ),
      child: child,
    );
  }
}

///
///
///
///
///

class SuggestionUpperBar extends StatefulWidget {
  const SuggestionUpperBar({Key? key}) : super(key: key);

  @override
  State<SuggestionUpperBar> createState() => _SuggestionUpperBarState();
}

class _SuggestionUpperBarState extends State<SuggestionUpperBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          width: 40,
          height: 40,
          child: Stack(
            children: [
              Image(
                width: 35,
                image: AssetImage("./assets/icon/applogo.png"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: DDColor.primary.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Positioned(
                bottom: 2.5,
                right: 2.5,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: DDColor.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 5.5,
                child: Text(
                  "2",
                  style: TextStyle(
                    fontFamily: "NanumSR",
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                    color: DDColor.primary.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
