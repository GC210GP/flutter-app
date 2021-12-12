import 'package:blood_donation/util/global_variables.dart';
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

enum BLOOD_TYPE {
  plusA,
  plusB,
  plusAB,
  plusO,
  minusA,
  minusB,
  minusAB,
  minusO,
}

class _SuggestionPageViewState extends State<SuggestionPageView> {
  CarouselController controller = CarouselController();

  double pageOpacity = 0;

  List<Map<String, dynamic>> suggestionList = [
    {
      "nickname": "홍길동",
      "uid": "121545352",
      "bloodType": "A(+)", // 체계화 필요
      "location": "서울특별시 은평구",
      "sns": "@doky.sp",
      "corr": 0.95,
      "img":
          "https://sw.gachon.ac.kr/files/GA1/cms/attach/2/5c65d9c885649cf21365e270bc1a8bc7.jpg",
      "rels": ["강철수", "박영희", "이성민"] // [2,3,4] uid 기준 전송
    },
    {
      "nickname": "강철수",
      "uid": "45401542354",
      "bloodType": "A(+)",
      "location": "경기도 성남시",
      "sns": "@ycyc1999",
      "corr": 0.84,
      "img":
          "https://sw.gachon.ac.kr/files/GA1/cms/attach/2/7f1775b75a70aa502d3965c881cefc1a.jpg",
      "rels": ["박영희", "이성민"]
    },
    {
      "nickname": "박영희",
      "uid": "5479867423",
      "bloodType": "O(+)",
      "location": "서울특별시 성동구",
      "sns": "@awesome_hlifej",
      "corr": 0.54,
      "img":
          "https://sw.gachon.ac.kr/files/GA1/cms/attach/2/5c65d9c885649cf21365e270bc1a8bc7.jpg",
      "rels": ["박영희", "이성민"]
    },
    {
      "nickname": "이성민",
      "uid": "5479867423",
      "bloodType": "A(-)",
      "location": "경기도 광주시",
      "sns": "@doky.sp",
      "corr": 0.32,
      "img":
          "http://image.chosun.com/sitedata/image/201907/24/2019072400001_0.jpg",
      "rels": ["이성민", "강철수"]
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      pageOpacity = 1;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: Duration(milliseconds: 100),
      child: Column(
        children: [
          upperBar(),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Builder(
                builder: (context) {
                  List<Widget> caroselList = [];

                  for (Map<String, dynamic> i in suggestionList) {
                    i["nickname"];
                    i["bloodType"];
                    i["location"];
                    i["corr"];
                    i["img"];
                    i["rels"];
                    caroselList.add(
                      caroselItemLayout(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(140),
                                      boxShadow: [
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
                                            i["img"],
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        i["nickname"],
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      shadowBox(
                                        height: 35,
                                        color: Colors.red.shade300,
                                        width: i["bloodType"].length * 13.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "   " + i["bloodType"] + "   ",
                                          style: TextStyle(
                                            fontFamily: "NanumSR",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      CupertinoButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () => url.launch(
                                            "https://instagram.com/${i["sns"].substring(1, i["sns"].length)}"),
                                        child: shadowBox(
                                          height: 35,
                                          color: Colors.purple.shade300,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "   " + i["sns"] + "   ",
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
                                      shadowBox(
                                        height: 35,
                                        color: Colors.pink.shade300,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "   " + i["location"] + "   ",
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
                                        child: shadowBox(
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
                                                    (i["corr"] * 100)
                                                            .toString() +
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
                                      //                 fontWeight: FontWeight.w900,
                                      //                 fontSize: 11,
                                      //                 color: Colors.grey.shade500,
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
                                      //                 fontWeight: FontWeight.w900,
                                      //                 fontSize: 13,
                                      //                 color: Colors.red.shade300,
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SizedBox(
                                        width: 2000,
                                        child: CupertinoButton(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                                toId: 2,
                                                fromName: "nickname(2)",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (suggestionList.length == 0) {
                    caroselList.add(
                      caroselItemLayout(
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
                            Container(
                              height: 50,
                              width: 150,
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Text(
                                  "로그인",
                                  style: TextStyle(
                                    fontFamily: "NanumSR",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                                color: Colors.red.shade300,
                                padding: EdgeInsets.all(0),
                                onPressed: () =>
                                    Navigator.pushNamed(context, "/signin"),
                              ),
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

  Widget shadowBox({
    required Widget child,
    double? width,
    double? height,
    Alignment? alignment,
    Color? color,
  }) =>
      Container(
        alignment: alignment,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
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

  Widget caroselItemLayout({required Widget child}) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: shadowBox(child: child),
            ),
          ),
        ],
      );

  Widget upperBar() => Column(
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
                      color: Colors.red.shade800,
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
                      color: Colors.white,
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
                      color: Colors.red.shade800,
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
