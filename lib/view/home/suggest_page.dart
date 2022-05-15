import 'package:app/model/person.dto.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/message_view.dart';
import 'package:app/widget/button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

class SuggestionPageView extends StatefulWidget {
  const SuggestionPageView({Key? key}) : super(key: key);

  @override
  _SuggestionPageViewState createState() => _SuggestionPageViewState();
}

class _SuggestionPageViewState extends State<SuggestionPageView> {
  CarouselController controller = CarouselController();

  double pageOpacity = 0;

  List<Widget> caroselList = [];

  @override
  void initState() {
    super.initState();
    doSuggestion();
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
                  return CarouselSlider(
                    carouselController: controller,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      aspectRatio: 1 / 2,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        debugPrint("index: $index / reason: $reason");
                      },
                      onScrolled: (value) {
                        debugPrint("value: $value");
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

  void doSuggestion() {
    if (GlobalVariables.userDto == null) {
      caroselList.add(
        CaroselItemLayout(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "로그인하시면\n도움이 필요한 분을 찾아드려요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h3,
                  color: DDColor.fontColor,
                ),
              ),
              const SizedBox(height: 20),
              DDButton(
                label: "로그인",
                width: 100,
                onPressed: () => Navigator.pushNamed(context, "/signin"),
              ),
            ],
          ),
        ),
      );
    } else if (GlobalVariables.suggestionList.isEmpty) {
      caroselList.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "아직 추천 리스트가 없어요 😭\n[커뮤니티] 탭에서 새로운 대화를 시작해보세요.\n\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h4,
                  color: DDColor.grey,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ///
      ///
      ///
      ///

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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(130),
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
                            width: user.bloodType.toString().length * 13.0,
                            alignment: Alignment.center,
                            child: Text(
                              "   " + user.bloodType.toString() + "   ",
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
                                "   " + user.sns[0].snsProfile + "   ",
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thermostat_sharp,
                                    color: Colors.red.shade300,
                                    size: 40,
                                  ),
                                  SizedBox(width: 7),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "나와의 온도",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "NanumSR",
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                      Text(
                                        // TODO: Correlation 값
                                        (0.23 * 100).toString() + "℃",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "NanumSR",
                                          fontWeight: FontWeight.w900,
                                          fontSize: 22,
                                          color: Colors.red.shade300,
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(
                                      GlobalVariables.radius),
                                  child: Text(
                                    "대화 시작하기",
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
                                        fromId: GlobalVariables.userDto!.uid,
                                        toId: user.uid,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              SizedBox(
                                width: 75,
                                child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(
                                      GlobalVariables.radius),
                                  child: Icon(CupertinoIcons.star_fill),
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

    }
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
///
///
///
///
///
///
///
///
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
  final int count;

  const SuggestionUpperBar({
    Key? key,
    this.count = 0,
  }) : super(key: key);

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
              const Image(
                width: 35,
                image: AssetImage("./assets/icon/applogo.png"),
              ),
              if (widget.count != 0)
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
              if (widget.count != 0)
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
              if (widget.count != 0)
                Positioned(
                  bottom: 2,
                  right: 5.5,
                  child: Text(
                    widget.count.toString(),
                    style: TextStyle(
                      fontFamily: DDFontFamily.nanumSR,
                      fontWeight: DDFontWeight.extraBold,
                      fontSize: DDFontSize.h6,
                      color: DDColor.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
