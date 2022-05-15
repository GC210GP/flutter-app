import 'package:app/model/person.dto.dart';
import 'package:app/util/chat/chat_data.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/message_view.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/user_informations.dart';
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> doSuggestion() async {
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
    } else if (GlobalVariables.suggestionList.isNotEmpty) {
      ///

      for (int targetUserId in GlobalVariables.suggestionList) {
        // 사용자 포스트 중 활성개수 수집
        int activeNum = 0;

        Map<String, dynamic> resultPosts = await GlobalVariables.httpConn
            .get(apiUrl: "/posts/users/$targetUserId");

        if (resultPosts['httpConnStatus'] == httpConnStatus.success) {
          for (Map<String, dynamic> post in resultPosts['data']) {
            if (!post['postResponseDto']['isActiveReceiver']) {
              activeNum++;
            }
          }
        }

        if (activeNum > 0) {
          caroselList.add(
            CaroselItemLayout(
              child: UserInformations(
                toId: targetUserId,
                padding: const EdgeInsets.all(20.0),
                chatFrom: ChatFrom.suggestion,
              ),
            ),
          );
        }
      }

      // 추천 이후 안내 페이지
      if (caroselList.isNotEmpty) {
        caroselList.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "여기까지가 추천 리스트입니다!\n[커뮤니티] 탭에서 새로운 대화를 시작해보세요.\n\n",
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
      }
    }

    //

    if (caroselList.isEmpty) {
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
        borderRadius: BorderRadius.circular(GlobalVariables.radius + 15.0),
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
        const SizedBox(height: 20),
        SizedBox(
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
      ],
    );
  }
}
