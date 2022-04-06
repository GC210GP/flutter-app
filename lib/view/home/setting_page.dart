import 'dart:convert';

import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/view/settting_text_view.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import 'dart:convert' as convert;

class SettingPageView extends StatefulWidget {
  const SettingPageView({Key? key}) : super(key: key);

  @override
  _SettingPageViewState createState() => _SettingPageViewState();
}

class _SettingPageViewState extends State<SettingPageView> {
  double pageOpacity = 0;

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
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///
              ///
              ///
              // 제목
              const PageTitleWidget(title: "설정"),

              ///
              ///
              ///
              // 내용
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SettingListItem(
                      height: 100,
                      children: [
                        Text(
                          "테스트1",
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        Text(
                          "김도균",
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          "test@naver.com",
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      onPressed: () {},
                    ),

                    ///
                    ///
                    ///

                    const Divider(height: 50),

                    ///
                    ///
                    ///

                    SettingListItem(
                      title: "📄  이용약관", //📃
                      margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingTextView(
                            title: "이용약관",
                            content: exampleText,
                          ),
                        ),
                      ),
                    ),
                    SettingListItem(
                      title: "🔒  개인정보보호방침",
                      margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingTextView(
                            title: "개인정보보호방침",
                            content: exampleText,
                          ),
                        ),
                      ),
                    ),
                    SettingListItem(
                      title: "🎁  오픈소스 라이센스",
                      // margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingTextView(
                            title: "오픈소스 라이센스",
                            content: exampleText,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 50,
                    ),
                    SettingListItem(
                      title: "🏠  더블디 홈페이지",
                      margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () => url.launch(
                        "https://doky.space",
                        forceSafariVC: false,
                      ),
                    ),
                    SettingListItem(
                      title: "🛠  계정 및 기타문의",
                      margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () => url.launch(
                        Uri(
                          scheme: 'mailto',
                          path: 'doubld@gmail.com',
                          query:
                              'subject=[더블디] ${'OOO'}님 계정 및 기타문의&body=카테고리: [ 계정 | 장애 | 건의사항 | 기타 ]\n문의내용:&cc=uhug@gachon.ac.kr, 2rhgywls@gachon.ac.kr, cyc0227@gachon.ac.kr',
                        ).toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingListItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? margin;
  final String? title;
  final List<Widget>? children;
  final double? height;

  SettingListItem({
    Key? key,
    this.title,
    this.margin,
    this.onPressed,
    this.children,
    this.height,
  }) : super(key: key) {
    assert(title != null || children != null);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        margin: margin,
        height: height ?? 60,
        decoration: BoxDecoration(
          color: DDColor.widgetBackgroud,
          borderRadius: BorderRadius.circular(GlobalVariables.radius),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 25, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.grey.shade900,
                        ),
                      )
                    else
                      ...?children,
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_forward,
                color: DDColor.primary,
              ),
            ],
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
