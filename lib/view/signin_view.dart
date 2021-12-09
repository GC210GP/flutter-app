import 'package:blood_donation/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SigninView extends StatefulWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  _SigninViewState createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 75),
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
                child: InputBox(),
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
                child: InputBox(),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(height: 75),
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
              onPressed: () => Navigator.pushNamed(context, "/signin"),
            ),
          ),
        ],
      ),
    );
  }
}
