import 'package:app/model/person.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/preference_manager.dart';
import 'package:app/util/privacy_policies.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/toast.dart';
import 'package:app/view/settting_text_view.dart';
import 'package:app/view/signin_view.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/view/signup/signup_page5.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 75),
                physics: const BouncingScrollPhysics(),
                children: [
                  const DDPageTitleWidget(title: "설정"),
                  SettingListItem(
                    height: 100,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobalVariables.userDto != null
                                      ? GlobalVariables.userDto!.nickname
                                      : "\n로그인이 필요합니다.",
                                  style: TextStyle(
                                    fontFamily: "NanumSR",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                Text(
                                  GlobalVariables.userDto != null
                                      ? GlobalVariables.userDto!.name
                                      : "",
                                  style: TextStyle(
                                    fontFamily: "NanumSR",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  GlobalVariables.userDto != null
                                      ? GlobalVariables.userDto!.email
                                      : "",
                                  style: TextStyle(
                                    fontFamily: "NanumSR",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (GlobalVariables.userDto != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                GlobalVariables.userDto!.profileImageLocation,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                    ],

                    // TODO: User 정보 수정
                    // onPressed: () => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => Scaffold(
                    //       body: SignPage5(
                    //         nickname: GlobalVariables.userDto!.nickname,
                    //         email: GlobalVariables.userDto!.email,
                    //         onPressed: ({
                    //           String? address,
                    //           DateTime? birthdate,
                    //           BloodType? bloodType,
                    //           bool? isDonated,
                    //           String? job,
                    //           Gender? sex,
                    //         }) {
                    //           GlobalVariables.userDto!.location = address!;
                    //           GlobalVariables.userDto!.birthdate = birthdate!;
                    //           GlobalVariables.userDto!.sex = sex!;
                    //           GlobalVariables.userDto!.isDonated = isDonated!;
                    //           GlobalVariables.userDto!.job = job!;
                    //           GlobalVariables.userDto!.bloodType = bloodType!;
                    //         },
                    //         onBackPressed: () => Navigator.pop(context),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    onPressed: GlobalVariables.userDto != null
                        ? () {
                            showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                title: const Text("로그아웃 하시겠습니까?"),
                                actions: [
                                  CupertinoButton(
                                    child: Text(
                                      "예",
                                      style: TextStyle(color: DDColor.primary),
                                    ),
                                    onPressed: doLogout,
                                  ),
                                  CupertinoButton(
                                    child: const Text("아니오"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          }
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SigninView(),
                              ),
                            ),
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
                        builder: (_) => const SettingTextView(
                          title: "이용약관",
                          content: PrivacyPolicies.policies,
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
                        builder: (_) => const SettingTextView(
                          title: "개인정보보호방침",
                          content: PrivacyPolicies.privacy,
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
                        builder: (_) => const SettingTextView(
                          title: "오픈소스 라이센스",
                          content: PrivacyPolicies.ossNotice,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 50.0),
                  SettingListItem(
                    title: "🏠  더블디 홈페이지",
                    margin: const EdgeInsets.only(bottom: 10.0),
                    onPressed: () => url.launch(
                      "https://github.com/GC210GP",
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
                        query: GlobalVariables.emailQuery(
                          GlobalVariables.userDto != null
                              ? GlobalVariables.userDto!.name
                              : null,
                        ),
                      ).toString(),
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

  Future<void> doLogout() async {
    await GlobalVariables.httpConn.patch(
      apiUrl: "/users/${GlobalVariables.userDto!.uid}",
      body: {"fbToken": ""},
    );

    GlobalVariables.fcmToken = "";
    GlobalVariables.userDto = null;
    PreferenceManager.instance.delete(target: PrefItem.token);
    GlobalVariables.httpConn.setHeaderToken("");

    DDToast.showToast("로그아웃 되었습니다 👋");

    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
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
