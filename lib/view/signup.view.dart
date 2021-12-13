import 'dart:io';

import 'package:blood_donation/util/global_variables.dart';
import 'package:blood_donation/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:intl/intl.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

enum BLOOD_TYPE {
  PLUS_A,
  PLUS_B,
  PLUS_AB,
  PLUS_O,
  MINUS_A,
  MINUS_B,
  MINUS_AB,
  MINUS_O,
}

class _SignupViewState extends State<SignupView> {
  bool isSignFailed = false;

  String name = "";
  String nickname = "";
  String email = "";
  String password = "";
  String phoneNumber = "";
  String profileImageLocation = ""; // "img1"
  DateTime birthdate = DateTime.now(); //": "2021-12-02",
  String location = ""; // "loc1",
  String sex = "MALE";
  String job = ""; // "job1",
  BLOOD_TYPE bloodType = BLOOD_TYPE.PLUS_A; // "PLUS_A",
  String bloodTypeLabel = "A형 RH+"; // "PLUS_A",
  DateTime recency = DateTime.now(); // ": "2021-12-02",
  // frequency": "1",
  // isDonated": "false",
  // isDormant": "false"
  String sns = "";

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
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height: 80),
                    Text(
                      "회원가입",
                      style: TextStyle(
                        fontFamily: "NanumSR",
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 30),
                    textField(title: "이름", onChanged: (v) => name = v),
                    textField(title: "닉네임", onChanged: (v) => nickname = v),
                    textField(title: "이메일", onChanged: (v) => email = v),
                    textField(
                        title: "비밀번호",
                        isObscureText: true,
                        onChanged: (v) => password = v),
                    textField(
                        title: "휴대폰 번호", onChanged: (v) => phoneNumber = v),
                    SizedBox(
                      width: 250,
                      height: 20,
                      child: Text(
                        "    프로필사진",
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.shade200,
                        child: Text(
                          "사진 업로드",
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(height: 25),

                    SizedBox(
                      width: 250,
                      height: 20,
                      child: Text(
                        "    생년월일",
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),

                    Container(
                      width: 250,
                      height: 35,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.shade200,
                        child: Text(
                          DateFormat("yyyy-MM-dd").format(birthdate).toString(),
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime.now(),
                            onConfirm: (date) {
                              birthdate = date;
                              setState(() {});
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.ko,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 25),

                    textField(
                        title: "거주지(특별시도 시군구)", onChanged: (v) => location = v),
                    SizedBox(
                      width: 250,
                      height: 20,
                      child: Text(
                        "    성별",
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "남자",
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        SizedBox(width: 10),
                        CupertinoSwitch(
                          trackColor: Colors.purple,
                          activeColor: Colors.orange,
                          value: sex != "MALE",
                          onChanged: (value) {
                            sex = value ? "FEMALE" : "MALE";
                            setState(() {});
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          "여자",
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    textField(title: "직업", onChanged: (v) => job = v),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: Divider(),
                    ),
                    SizedBox(
                      width: 250,
                      height: 20,
                      child: Text(
                        "    혈액형",
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.shade200,
                        child: Text(
                          bloodTypeLabel,
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onPressed: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              title: const Text('\n자신의 혈액형을 선택하세요\n'),
                              // message: const Text(''),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  child: const Text('A형 RH+'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.PLUS_A;
                                    bloodTypeLabel = "A형 RH+";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('B형 RH+'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.PLUS_B;
                                    bloodTypeLabel = "B형 RH+";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('AB형 RH+'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.PLUS_AB;
                                    bloodTypeLabel = "AB형 RH+";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('O형 RH+'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.PLUS_O;
                                    bloodTypeLabel = "O형 RH+";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),

                                ///

                                CupertinoActionSheetAction(
                                  child: const Text('A형 RH-'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.MINUS_A;
                                    bloodTypeLabel = "A형 RH-";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('B형 RH-'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.MINUS_B;
                                    bloodTypeLabel = "B형 RH-";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('AB형 RH-'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.MINUS_AB;
                                    bloodTypeLabel = "AB형 RH-";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('O형 RH-'),
                                  onPressed: () {
                                    bloodType = BLOOD_TYPE.MINUS_O;
                                    bloodTypeLabel = "O형 RH-";
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 25),

                    SizedBox(
                      width: 250,
                      height: 20,
                      child: Text(
                        "    최근 헌혈일",
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 35,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.shade200,
                        child: Text(
                          DateFormat("yyyy-MM-dd").format(recency).toString(),
                          style: TextStyle(
                            fontFamily: "NanumSR",
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime.now(),
                            onConfirm: (date) {
                              recency = date;
                              setState(() {});
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.ko,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 25),

                    textField(title: "SNS 아이디", onChanged: (v) => sns = v),

                    SizedBox(
                      width: 250,
                      height: 50,
                      child: Divider(),
                    ),

                    ///
                    ///
                    ///

                    SizedBox(height: 25),
                    SizedBox(
                      width: 250,
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
                        color: Colors.red.shade300,
                        padding: EdgeInsets.all(0),
                        onPressed: () => doSignup(),
                      ),
                    ),
                    SizedBox(height: 15),
                    if (isSignFailed)
                      Text(
                        "입력하신 정보가 올바르지 않습니다",
                        style: TextStyle(
                          fontFamily: "NanumSR",
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                          color: Colors.red.shade400,
                        ),
                      )
                    else
                      SizedBox(height: 15),
                    SizedBox(height: 250),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textField({
    required String title,
    Function(String)? onChanged,
    bool isObscureText = false,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "    $title",
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
              obscureText: isObscureText,
              onChanged: onChanged,
            ),
          ),
          SizedBox(height: 15),
        ],
      );

  Future<void> doSignup() async {
    int id = -1;

    var body = convert.json.encode({
      "name": name,
      "nickname": nickname,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "profileImageLocation": "img1",
      "birthdate": DateFormat("yyyy-MM-dd").format(birthdate).toString(),
      "location": location,
      "sex": sex,
      "job": job,
      "bloodType": bloodType.toString().split(".")[1],
      "recency": DateFormat("yyyy-MM-dd").format(birthdate).toString(),
      "frequency": "1",
      "isDonated": "false",
      "isDormant": "false"
    });

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };

    print(GlobalVariables.baseurl + "/users");

    http.Response response = await http.post(
      Uri.parse(GlobalVariables.baseurl + "/users"),
      body: body,
      headers: headers,
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode < 400) {
      Map<String, dynamic> result = convert.jsonDecode(response.body);
      id = result["data"]["id"];
      GlobalVariables.userIdx = id;
      // TODO: Save this to fs
      Navigator.pushReplacementNamed(context, "/splash");
    } else {
      isSignFailed = true;
      setState(() {});
    }

    ///
    ///
    ///

    // body = convert.json.encode({
    //   "userId": 2,
    //   "snsType": "FACEBOOK",
    //   "snsProfile": "test",
    // });

    // headers = {
    //   HttpHeaders.contentTypeHeader: 'application/json',
    //   HttpHeaders.acceptHeader: 'application/json',
    // };

    // print(GlobalVariables.baseurl + "/users/sns");

    // response = await http.post(
    //   Uri.parse(GlobalVariables.baseurl + "/users/sns"),
    //   body: body,
    //   headers: headers,
    // );
  }
}
