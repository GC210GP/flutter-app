import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionPageView extends StatefulWidget {
  const SuggestionPageView({Key? key}) : super(key: key);

  @override
  _SuggestionPageViewState createState() => _SuggestionPageViewState();
}

class _SuggestionPageViewState extends State<SuggestionPageView> {
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
              Image(
                width: 35,
                image: AssetImage("./assets/icon/applogo.png"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Positioned(
                bottom: 2.5,
                right: 2.5,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 5.5,
                child: Text(
                  "2",
                  style: TextStyle(
                    fontFamily: "NanumSR",
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                    color: Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        Expanded(
          child: Container(
            height: 500,
            width: 330,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 4),
                  spreadRadius: 0.0,
                  blurRadius: 7.0,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "로그인하시면\n도움이 필요한\n친구들을 찾아드립니다",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "NanumSR",
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.grey.shade900,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 150,
                  child: CupertinoButton(
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
                    onPressed: () => Navigator.pushNamed(context, "/home"),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
