import 'package:blood_donation/util/colors.dart';
import 'package:blood_donation/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                      title: "이용약관",
                      margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () {},
                    ),
                    SettingListItem(
                      title: "개인정보보호방침",
                      margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () {},
                    ),
                    SettingListItem(
                      title: "오픈소스 라이센스",
                      margin: const EdgeInsets.only(bottom: 10.0),
                      onPressed: () {},
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
          borderRadius: BorderRadius.circular(15),
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
