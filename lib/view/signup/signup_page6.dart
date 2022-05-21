import 'package:app/model/person.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/dropdown_button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// SNS 등록
class SignPage6 extends StatefulWidget {
  final Function(List<SnsDto>)? onPressed;
  final VoidCallback? onBackPressed;

  final String nickname;
  final String email;
  final String profileImageLocation;

  const SignPage6({
    Key? key,
    required this.nickname,
    required this.email,
    required this.profileImageLocation,
    this.onPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<SignPage6> createState() => _SignPage6State();
}

double pageOpacity = 0.0;
bool isError = false;

List<SnsDto> snsList = [];

class _SignPage6State extends State<SignPage6> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      pageOpacity = 1.0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: Center(
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
                        nickname: widget.nickname,
                        email: widget.email,
                        imgUrl: widget.profileImageLocation,
                      ),
                    ),

                    const SizedBox(height: 25.0),

                    Center(
                      child: Text(
                        "마지막이에요!",
                        textAlign: TextAlign.center,
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
                        textAlign: TextAlign.center,
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
                        "SNS 계정을 등록해주세요!",
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
                            SizedBox(
                              width: 115.0,
                              child: DDDropdownButton(
                                  labelText: "페이스북",
                                  items: const ["페이스북", "인스타", "트위터", "카카오"],
                                  onChanged: (value) {
                                    switch (value) {
                                      case "페이스북":
                                        snsList[i].snsType = SnsType.FACEBOOK;
                                        break;
                                      case "인스타":
                                        snsList[i].snsType = SnsType.INSTAGRAM;
                                        break;
                                      case "트위터":
                                        snsList[i].snsType = SnsType.TWITTER;
                                        break;
                                      case "카카오":
                                        snsList[i].snsType = SnsType.KAKAO;
                                        break;
                                    }
                                  }),
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: DDTextField(
                                hintText: "아이디(이메일X)",
                                onChanged: (value) =>
                                    snsList[i].snsProfile = value,
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
                            snsList.add(
                              SnsDto(snsType: SnsType.FACEBOOK, snsProfile: ""),
                            );
                            setState(() {});
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    if (isError)
                      Center(
                        child: Text(
                          "모든 항목을 빠짐없이 입력해주세요!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: DDFontFamily.nanumSR,
                            fontWeight: DDFontWeight.extraBold,
                            fontSize: DDFontSize.h5,
                            color: DDColor.primary,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 14.5),

                    const SizedBox(height: 20.0),

                    Center(
                      child: DDButton(
                        width: 110,
                        label: "가입하기",
                        onPressed: () {
                          if (widget.onPressed != null) {
                            for (SnsDto i in snsList) {
                              if (i.snsProfile.isEmpty) {
                                setState(() {
                                  isError = true;
                                });
                                return;
                              }
                            }
                            widget.onPressed!(snsList);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    Center(
                      child: DDButton(
                        width: 40.0,
                        height: 40.0,
                        child: const Icon(Icons.arrow_back_rounded),
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
      ),
    );
  }
}
