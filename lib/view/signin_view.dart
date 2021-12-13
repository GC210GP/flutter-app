import 'dart:io';

import 'package:blood_donation/util/global_variables.dart';
import 'package:blood_donation/widget/input_box.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:jwt_decode/jwt_decode.dart';

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
      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("./assets/icon/applogo.png"),
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "더블디",
                      style: TextStyle(
                        fontFamily: "NanumSR",
                        fontWeight: FontWeight.w900,
                        fontSize: 45,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "    아이디",
                      style: TextStyle(
                        fontFamily: "NanumSR",
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 250,
                      height: 37,
                      child: InputBox(
                        onChanged: (value) => userId = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "    비밀번호",
                      style: TextStyle(
                        fontFamily: "NanumSR",
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 250,
                      height: 37,
                      child: InputBox(
                        obscureText: true,
                        onChanged: (value) => userPw = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(50.0),
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
                    onPressed: () => doLogin(userid: userId, userpw: userPw),
                  ),
                ),
                SizedBox(height: 15),
                if (isLoginFailed)
                  Text(
                    "계정 정보가 올바르지 않습니다",
                    style: TextStyle(
                      fontFamily: "NanumSR",
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      color: Colors.red.shade400,
                    ),
                  )
                else
                  SizedBox(height: 15),
                SizedBox(height: 45),
                Text(
                  "아직 회원이 아니신가요?",
                  style: TextStyle(
                    fontFamily: "NanumSR",
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 7),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Text(
                      "회원가입",
                      style: TextStyle(
                        fontFamily: "NanumSR",
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: Colors.grey.shade100,
                      ),
                    ),
                    color: Colors.grey.shade400,
                    padding: EdgeInsets.all(0),
                    onPressed: () => Navigator.pushNamed(context, "/signup"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doLogin({
    required String userid,
    required String userpw,
  }) async {
    var body = convert.json.encode(
      {"email": userid, "password": userpw},
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };

    http.Response response = await http.post(
      Uri.parse(GlobalVariables.baseurl + "/auth"),
      body: body,
      headers: headers,
    );

    Map<String, dynamic> result = convert.jsonDecode(response.body);

    if (result.keys.contains("token")) {
      Map<String, dynamic> payload = Jwt.parseJwt(result['token']);
      GlobalVariables.userIdx = int.parse(payload['sub']);

      response = await http.get(Uri.parse(GlobalVariables.baseurl +
          "/users?userId=" +
          GlobalVariables.userIdx.toString()));

      result = convert.jsonDecode(response.body);

      if (result.keys.contains("data")) {
        // print(response.body);
        Navigator.pushReplacementNamed(context, "/splash");
        return;
      }
    }

    isLoginFailed = true;
    setState(() {});
  }
}
