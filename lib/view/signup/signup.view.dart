import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/signup/signup_page1.dart';
import 'package:app/view/signup/signup_page2.dart';
import 'package:app/view/signup/signup_page3.dart';
import 'package:app/view/signup/signup_page4.dart';
import 'package:app/view/signup/signup_page5.dart';
import 'package:app/view/signup/signup_page6.dart';
import 'package:app/view/signup/signup_page7.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DDColor.background,
      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body:
          //

          //     SignupPage1(
          //   title: "이용약관",
          //   content: exampleText,
          //   buttonTitle: "이용약관 동의",
          //   onPressed: () {},
          // ),

          //     SignupPage1(
          //   title: "개인정보보호방침",
          //   content: exampleText,
          //   buttonTitle: "개인정보보호방침 동의",
          //   onPressed: () {},
          // ),

          //     SignupPage2(
          //   onPressed: () {},
          //   onBackPressed: () {},
          //   title: "이메일을 입력해주세요",
          //   errorMessage: "이메일을 올바르게 입력해주세요",
          // ),

          // SignupPage3(),

          //     SignupPage2(
          //   onPressed: () {},
          //   onBackPressed: () {},
          //   title: "비밀번호를 입력해주세요",
          //   errorMessage: "비밀번호를 올바르게 입력해주세요",
          // ),

          //     SignupPage2(
          //   onPressed: () {},
          //   onBackPressed: () {},
          //   title: "한 번 더 입력해주세요",
          //   errorMessage: "비밀번호가 다릅니다",
          // ),

          // SignPage4(),

          SignPage5(),
      // SignPage6(),
      // SignPage7(),
    );
  }

  ///
  ///
  ///
  ///
  ///

  Future<void> doSignup() async {
    // var body = convert.json.encode({
    //   "name": name,
    //   "nickname": nickname,
    //   "email": email,
    //   "password": password,
    //   "phoneNumber": phoneNumber,
    //   "profileImageLocation": "img1",
    //   "birthdate": DateFormat("yyyy-MM-dd").format(birthdate).toString(),
    //   "location": location,
    //   "sex": sex,
    //   "job": job,
    //   "bloodType": bloodType.toString().split(".")[1],
    //   "recency": DateFormat("yyyy-MM-dd").format(birthdate).toString(),
    //   "frequency": "1",
    //   "isDonated": "false",
    //   "isDormant": "false"
    // });

    // Map<String, String> headers = {
    //   HttpHeaders.contentTypeHeader: 'application/json',
    //   HttpHeaders.acceptHeader: 'application/json',
    // };
  }

  ///
  ///
  ///
  ///
  ///
  ///

}

///
///
///
///
///
///
///
///
///

class ProfileItem extends StatelessWidget {
  final String nickname;
  final String email;
  final String imgUrl;

  const ProfileItem({
    Key? key,
    required this.nickname,
    required this.email,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: Image(image: NetworkImage(imgUrl)),
            ),
          ),
          const SizedBox(width: 10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$nickname 님",
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h3,
                  color: DDColor.fontColor,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h4,
                  color: DDColor.grey,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

String exampleText = """이용약관 & 개인정보보호방침
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent hendrerit egestas facilisis. Nunc sit amet lorem id arcu volutpat aliquam a ac ex. Nulla a hendrerit magna. Cras id sodales lorem, vel facilisis libero. Fusce ullamcorper finibus diam, eu vestibulum ex blandit eget. Donec interdum pulvinar quam quis condimentum. Nunc diam urna, euismod eu dapibus ac, fermentum a arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut placerat elit vitae vulputate finibus. Vestibulum vel porta mi, a aliquam leo. Cras egestas faucibus urna vel aliquam. Integer ac ipsum nunc.

  Nulla efficitur eros vehicula laoreet bibendum. Morbi et magna sit amet tortor euismod molestie. Donec cursus risus consequat, eleifend elit sed, varius ex. Etiam rhoncus venenatis urna ullamcorper lacinia. Integer dolor elit, semper et condimentum in, lobortis at lorem. Duis finibus efficitur fermentum. Cras fermentum in erat id consectetur. Donec facilisis tempus arcu, ac tristique magna tempus id. Cras tincidunt malesuada molestie. Fusce quis molestie odio, vel scelerisque ligula. Integer arcu elit, blandit a libero quis, suscipit commodo velit. Aliquam iaculis quam ac mauris viverra efficitur. Fusce eget pretium quam. Nunc venenatis sollicitudin elit eu rutrum. Nulla facilisi. Vestibulum efficitur arcu ut facilisis euismod.

  Phasellus eu enim at ex volutpat malesuada. Sed tempus libero nec venenatis pulvinar. Sed imperdiet erat non diam volutpat tristique. Nullam orci ante, aliquam eu risus sed, porttitor vulputate libero. Proin molestie magna felis, eu aliquet massa scelerisque a. Duis ultrices mattis tortor eu consectetur. Duis nec finibus nunc.

  Donec at mattis massa. Integer eros nibh, porta ac scelerisque eu, pellentesque quis odio. Sed euismod magna in odio consequat elementum. Phasellus molestie mattis lectus non feugiat. Sed in dolor libero. Nulla eu sapien ut enim convallis sodales. Donec viverra consequat nibh, a hendrerit velit dignissim eget. Suspendisse dapibus feugiat neque, in feugiat sem bibendum sit amet. Sed pellentesque consectetur massa nec fermentum. Aenean laoreet blandit nunc, quis volutpat augue laoreet eget. Duis efficitur commodo elit, sit amet laoreet ante accumsan in. Ut id lectus ante. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

  Proin quis mauris eget purus efficitur elementum sed vitae erat. Cras dolor erat, accumsan id pulvinar in, sollicitudin quis magna. Ut in consectetur enim. Phasellus pretium eget orci sed blandit. Sed mattis ipsum felis, scelerisque ultricies odio luctus non. Proin orci lectus, lacinia at justo ac, tincidunt lacinia purus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam porta, est ut dapibus egestas, augue elit faucibus metus, ut lacinia lectus mi ac massa. Donec suscipit vulputate nisl sit amet egestas. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce pretium est in aliquam aliquam. Suspendisse blandit turpis quis quam fermentum elementum.""";
