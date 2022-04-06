import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/material.dart';

class SigninView extends StatefulWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  _SigninViewState createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  String userId = "";
  String userPw = "";
  bool isLoginFailed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DDColor.background,
      appBar: DDAppBar(context, title: "홈"),
      body: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            children: [
              ///
              ///
              ///

              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage("./assets/icon/applogo.png"),
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "더블디",
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h1,
                            color: DDColor.primary,
                          ),
                        ),
                      ],
                    ),

                    ///
                    ///
                    ///

                    const SizedBox(height: 50),

                    ///
                    ///
                    ///

                    Text(
                      "아이디",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h5,
                        color: DDColor.grey,
                      ),
                    ),

                    DDTextField(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                      onChanged: (value) => userId = value,
                    ),

                    Text(
                      "비밀번호",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h5,
                        color: DDColor.grey,
                      ),
                    ),

                    DDTextField(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 30.0),
                      obscureText: true,
                      onChanged: (value) => userPw = value,
                    ),

                    ///
                    ///
                    ///

                    if (isLoginFailed)
                      Text(
                        "계정 정보가 올바르지 않습니다",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: DDFontFamily.nanumSR,
                          fontWeight: DDFontWeight.extraBold,
                          fontSize: DDFontSize.h5,
                          color: DDColor.primary,
                        ),
                      )
                    else
                      const SizedBox(height: DDFontSize.h5 + 2),
                    const SizedBox(height: DDFontSize.h5),

                    ///
                    ///
                    ///

                    Center(
                      child: DDButton(
                        width: 115,
                        margin: const EdgeInsets.only(bottom: 50.0),
                        label: "로그인",
                        onPressed: () =>
                            doLogin(userid: userId, userpw: userPw),
                      ),
                    ),

                    ///
                    ///
                    ///

                    Text(
                      "아직 회원이 아니신가요?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),

                    ///
                    ///
                    ///

                    Center(
                      child: DDButton(
                        margin: const EdgeInsets.only(top: 10.0),
                        width: 130,
                        label: "회원가입",
                        color: DDColor.grey,
                        onPressed: () =>
                            Navigator.pushNamed(context, "/signup"),
                      ),
                    ),
                  ],
                ),
              ),

              ///
              ///
              ///
            ],
          ),
        ),
      ),
    );
  }

  Future<void> doLogin({
    required String userid,
    required String userpw,
  }) async {
    isLoginFailed = true;
    setState(() {});
  }
}
