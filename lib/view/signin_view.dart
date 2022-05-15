import 'package:app/model/person.dto.dart';
import 'package:app/model/token.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/preference_manager.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/util/toast.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

class SigninView extends StatefulWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  _SigninViewState createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  String userId = "";
  String userPw = "";
  bool isLoginFailed = false;
  bool isWorking = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = GlobalVariables.savedEmail;
    userId = GlobalVariables.savedEmail;
    super.initState();
  }

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
                      controller: _controller,
                      keyboardType: TextInputType.emailAddress,
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
                        "계정 정보를 확인해주세요!",
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
                      child: Stack(
                        children: [
                          DDButton(
                            width: 115,
                            // margin: const EdgeInsets.only(bottom: 50.0),
                            label: "로그인",
                            onPressed: () =>
                                doLogin(userid: userId, userpw: userPw),
                          ),
                          if (isWorking)
                            Positioned.fill(
                              child: Container(
                                color: Colors.white.withOpacity(0.5),
                                child: const CupertinoActivityIndicator(
                                  radius: 15.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    Center(
                      child: DDButton(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 40.0),
                        height: 30,
                        child: Text(
                          "아이디/비밀번호가 기억나지 않아요 😭",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h4,
                            color: DDColor.fontColor,
                          ),
                        ),
                        color: DDColor.background,
                        onPressed: () => url.launch(
                          Uri(
                            scheme: 'mailto',
                            path: 'doubld@gmail.com',
                            query: GlobalVariables.emailAccountQuery,
                          ).toString(),
                        ),
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
    ///
    ///
    ///
    // TODO: Refactoring

    setState(() {
      isWorking = true;
    });

    TokenDto? tokenResult = await GlobalVariables.httpConn
        .auth(email: userid.trim(), password: userpw.trim());

    if (tokenResult != null) {
      isLoginFailed = false;

      Map<String, dynamic> userResult =
          await GlobalVariables.httpConn.get(apiUrl: "/users/current");

      if (userResult['httpConnStatus'] == httpConnStatus.success) {
        // 로그인 시, fcm 토큰 업데이트
        await GlobalVariables.httpConn
            .patch(apiUrl: "/users/${tokenResult.id}", body: {
          "fbToken": GlobalVariables.fcmToken,
        });
        debugPrint("FB Token changed!");

        ///
        ///
        ///

        AddUserUserDto tmpUser = AddUserUserDto(
          name: "unknown",
          nickname: "unknown",
          email: userResult['data']['email'],
          sns: [],
          phoneNumber: "unknown",
          profileImageLocation: "",
          birthdate: GlobalVariables.defaultDateTime,
          location: "unknown",
          sex: Gender.MALE,
          job: "",
          fbToken: userResult['data']['fbToken'],
          bloodType: BloodType.PLUS_A,
          isDormant: false,
          isDonated: false,
          createdDate: GlobalVariables.defaultDateTime,
          updatedDate: GlobalVariables.defaultDateTime,
          frequency: 0,
          password: userpw.trim(),
          recency: GlobalVariables.defaultDateTime,
        );

        print(tokenResult);

        // 이메일 인증 안한 경우!
        if (tokenResult.auth == Auth.ROLE_NEED_EMAIL) {
          TokenDto? loginResult = await GlobalVariables.httpConn
              .auth(email: tmpUser.email, password: tmpUser.password);

          print(loginResult);

          if (loginResult != null) {
            Map<String, dynamic> result = await GlobalVariables.httpConn
                .post(apiUrl: "/users/validate-email");

            if (result["httpConnStatus"] == httpConnStatus.success) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SignupView(
                    userData: tmpUser,
                    uid: tokenResult.id,
                    pageIndex: 5,
                  ),
                ),
              );
              isWorking = false;
              setState(() {});
              return;
            }
            isLoginFailed = true;
            isWorking = false;
            setState(() {});
            return;
          } else {
            isLoginFailed = true;
            isWorking = false;
            setState(() {});
            return;
          }
        }

        // 회원가입 이후 별도 정보 입력 안한 경우!
        if (DateTime.parse(userResult['data']['birthdate']).hashCode ==
            GlobalVariables.defaultDateTime.hashCode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignupView(
                userData: tmpUser,
                uid: tokenResult.id,
                pageIndex: 6,
              ),
            ),
          );
          isWorking = false;
          setState(() {});
          return;
        }

        GlobalVariables.userDto = readUserDto(userResult);

        PreferenceManager.instance
            .update(token: tokenResult.token, savedEmail: userid.trim());
        GlobalVariables.savedEmail = userid.trim();
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        DDToast.showToast("👋");
        isWorking = false;
        setState(() {});
        return;
      }
    } else {
      isLoginFailed = true;
      isWorking = false;
    }

    setState(() {});
  }
}

///
///
///
///
///

UserDto readUserDto(Map<String, dynamic> userResult) {
  late Gender gender;
  late BloodType bloodType;

  for (var i in Gender.values) {
    if (i.name == userResult['data']['sex']) {
      gender = i;
      break;
    }
  }

  for (var i in BloodType.values) {
    if (i.name == userResult['data']['bloodType']) {
      bloodType = i;
      break;
    }
  }

  // TODO: 자기 SNS 불러오기 기능
  return UserDto(
    uid: userResult['data']['id'],
    name: userResult['data']['name'],
    nickname: userResult['data']['nickname'],
    email: userResult['data']['email'],
    sns: [],
    phoneNumber: userResult['data']['phoneNumber'],
    profileImageLocation: userResult['data']['profileImageLocation'],
    birthdate: DateTime.parse(userResult['data']['birthdate']),
    location: userResult['data']['location'],
    sex: gender,
    job: userResult['data']['job'],
    fbToken: userResult['data']['fbToken'],
    bloodType: bloodType,
    isDormant: userResult['data']['isDormant'],
    isDonated: userResult['data']['isDonated'],
    createdDate: DateTime.parse(userResult['data']['createdDate']),
    modifiedDate: DateTime.parse(userResult['data']['modifiedDate']),
  );
}
