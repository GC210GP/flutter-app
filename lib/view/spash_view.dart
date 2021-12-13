import 'package:blood_donation/widget/bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double logoSize = 1.0;
  bool isActive = false;
  int animationDuration = 500;

  Future<void> worker() async {
    Future.delayed(Duration(milliseconds: 3000)).then((value) {
      Navigator.pushReplacementNamed(context, "/home");
    });

    while (isActive) {
      await Future.delayed(Duration(milliseconds: animationDuration));
      logoSize = logoSize == 1.0 ? 1.2 : 1.0;

      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isActive = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      isActive = true;
      worker();
    }

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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 75,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      duration: Duration(milliseconds: animationDuration),
                      scale: logoSize,
                      curve: Curves.easeOutSine,
                      child: Image(
                        width: 60,
                        image: AssetImage("./assets/icon/applogo.png"),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "나의 도움이 필요한 친구를\n찾고 있어요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "NanumSR",
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 75,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
