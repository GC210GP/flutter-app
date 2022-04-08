import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/dropdown_button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';

// SNS 등록
class SignPage6 extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onBackPressed;

  const SignPage6({
    Key? key,
    this.onPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<SignPage6> createState() => _SignPage6State();
}

class _SignPage6State extends State<SignPage6> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 70.0, bottom: 50.0),
        children: [
          Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ProfileItem(
                      nickname: "홍길동",
                      email: "uhug@naver.com",
                      imgUrl: GlobalVariables.defaultImgUrl,
                    ),
                  ),

                  const SizedBox(height: 25.0),

                  Center(
                    child: Text(
                      "마지막이에요!",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "SNS 계정을 입력해주세요",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h3,
                        color: DDColor.fontColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      "SNS 계정을 등록하시면 헌혈자를\n더 빠르게 구할 수 있어요!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h5,
                        color: DDColor.primary.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50.0),

                  for (int i = 0; i < snsList.length; i++)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 115.0,
                            child: DDDropdownButton(
                              items: ["페이스북", "인스타", "트위터", "카카오"],
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: DDTextField(
                              hintText: "아이디(이메일X)",
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Center(
                            child: SizedBox(
                              width: 35.0,
                              height: 35.0,
                              child: DDButton(
                                child: const Icon(
                                  CupertinoIcons.xmark,
                                  size: 15.0,
                                ),
                                onPressed: () {
                                  snsList.removeAt(i);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Center(
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: DDButton(
                        label: "+",
                        onPressed: () {
                          snsList.add(0);
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 50.0),

                  Center(
                    child: DDButton(
                      width: 110,
                      label: "가입하기",
                      onPressed: widget.onPressed,
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  Center(
                    child: DDButton(
                      width: 40.0,
                      height: 40.0,
                      label: "←",
                      onPressed: widget.onBackPressed,
                      color: DDColor.disabled,
                    ),
                  ),

                  ///
                  ///
                  ///
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<int> snsList = [];
}
