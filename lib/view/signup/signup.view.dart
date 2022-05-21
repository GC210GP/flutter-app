import 'package:app/model/person.dto.dart';
import 'package:app/model/token.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/privacy_policies.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/signup/signup_page1.dart';
import 'package:app/view/signup/signup_page2.dart';
import 'package:app/view/signup/signup_page3.dart';
import 'package:app/view/signup/signup_page4.dart';
import 'package:app/view/signup/signup_page5.dart';
import 'package:app/view/signup/signup_page6.dart';
import 'package:app/view/signup/signup_page7.dart';
import 'package:app/view/signup/signup_page8.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SignupView extends StatefulWidget {
  final int pageIndex;
  final AddUserUserDto? userData;
  final int? uid;

  const SignupView({
    Key? key,
    this.pageIndex = 0,
    this.userData,
    this.uid,
  }) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  // 대소문자, 특수문자, 숫자 하나씩
  RegExp passwordRegex = RegExp(
      r"(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[-`~!@#$%^&*()_+=])[A-Za-z\d-`~!@#$%^&*()_+=]{8,}$");
  RegExp phoneRegex = RegExp(r"01(?:0|1|[6-9])-(?:\d{3}|\d{4})-\d{4}$");
  RegExp emailRegex =
      RegExp(r"[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
  // 영문,숫자 4~10자리
  RegExp idRegex = RegExp(r"(?=.*[a-zA-Z])[-a-zA-Z0-9_.]{4,10}$");

  late int currUid;
  Status signinStatus = Status.success;

  AddUserUserDto user = AddUserUserDto(
    name: "unknown",
    nickname: "unknown",
    email: "unknown",
    sns: [],
    phoneNumber: "unknown",
    profileImageLocation: "",
    birthdate: GlobalVariables.defaultDateTime,
    location: "unknown",
    sex: Gender.MALE,
    job: "",
    fbToken: "",
    bloodType: BloodType.PLUS_A,
    isDormant: false,
    isDonated: false,
    createdDate: GlobalVariables.defaultDateTime,
    updatedDate: GlobalVariables.defaultDateTime,
    frequency: 0,
    password: '',
    recency: GlobalVariables.defaultDateTime,
  );

  late int pageIdx;

  @override
  void initState() {
    currUid = widget.uid ?? -1;
    pageIdx = widget.pageIndex;
    if (widget.userData != null) {
      user = widget.userData!;
    }
    super.initState();
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (pageIdx == 0)
            Expanded(
              child: SignupPage1(
                title: "이용약관",
                content: PrivacyPolicies.policies,
                buttonTitle: "이용약관 동의",
                onPressed: () => changePage(1),
              ),
            )
          else if (pageIdx == 1)
            Expanded(
              child: SignupPage1(
                title: "개인정보보호방침",
                content: PrivacyPolicies.privacy,
                buttonTitle: "개인정보보호방침 동의",
                onPressed: () => changePage(2),
              ),
            )
          else if (pageIdx == 2)
            Expanded(
              child: SignupPage2(
                title: "이메일을 입력해주세요",
                errorMessage: "올바르지 않거나 이미 등록된 이메일입니다",
                validator: emailRegex,
                keyboardType: TextInputType.emailAddress,
                onPressed: (email) {
                  user.email = email;
                  changePage(3);
                },
                correctionCheck: isEmailExist,
                onBackPressed: () => Navigator.pop(context),
              ),
            )
          else if (pageIdx == 3)
            Expanded(
              child: SignupPage2(
                onPressed: (password) {
                  user.password = password;
                  changePage(4);
                },
                isObscureText: true,
                keyboardType: TextInputType.text,
                validator: passwordRegex,
                onBackPressed: () => changePage(2),
                title: "비밀번호를 입력해주세요",
                errorMessage: "대/소문자, 특수문자, 숫자를\n포함해서 입력해주세요",
              ),
            )
          else if (pageIdx == 4)
            Expanded(
              child: SignupPage2(
                onPressed: (_) async {
                  // 유저 생성
                  user.fbToken = GlobalVariables.fcmToken;
                  if (await createUser(user)) {
                    changePage(5);
                  }
                },
                onBackPressed: () => changePage(3),
                keyboardType: TextInputType.text,
                isObscureText: true,
                correctionCheck: (input) async {
                  return input == user.password;
                },
                title: "한 번 더 입력해주세요",
                errorMessage: "비밀번호가 일치하지 않습니다!",
                isTransition: false,
              ),
            )
          else if (pageIdx == 5)
            Expanded(
              child: SignupPage3(
                email: user.email,
                onCheckValidation: (code) async {
                  if (await checkUserEmailValidation(code)) {
                    await Future.delayed(const Duration(seconds: 1));
                    changePage(6);
                    return true;
                  } else {
                    return false;
                  }
                },
                // onBackPressed: () => changePage(2),
              ),
            )

          ///
          ///
          ///

          else if (pageIdx == 6)
            Expanded(
              child: SignPage4(
                onPressed: (String name, String imgUrl) {
                  user.name = name;
                  user.profileImageLocation = imgUrl;
                  changePage(7);
                },
                label: "이름 (실명)",
              ),
            )
          else if (pageIdx == 7)
            Expanded(
              child: SignPage4(
                imgUrl: user.profileImageLocation,
                onPressed: (String nickname, String imgUrl) {
                  user.nickname = nickname;
                  user.profileImageLocation = imgUrl;
                  changePage(8);
                },
                onBackPressed: () => changePage(8),
                label: "닉네임",
              ),
            )
          else if (pageIdx == 8)
            Expanded(
              child: SignPage5(
                nickname: user.nickname,
                email: user.email,
                profileImageLocation: user.profileImageLocation,
                onPressed: ({
                  String? address,
                  DateTime? birthdate,
                  BloodType? bloodType,
                  bool? isDonated,
                  String? job,
                  Gender? sex,
                }) {
                  user.location = address!;
                  user.birthdate = birthdate!;
                  user.sex = sex!;
                  user.isDonated = isDonated!;
                  user.job = job!;
                  user.bloodType = bloodType!;

                  changePage(9);
                },
                onBackPressed: () => changePage(7),
              ),
            )
          else if (pageIdx == 9)
            Expanded(
              child: SignPage6(
                nickname: user.nickname,
                email: user.email,
                profileImageLocation: user.profileImageLocation,
                onPressed: ((value) {
                  user.sns = value;
                  changeUserWorker(user);
                }),
                onBackPressed: () => changePage(8),
              ),
            )
          else if (pageIdx == 10)
            const Expanded(
              child: SignPage7(),
            )
          else if (pageIdx == 11)
            Expanded(
              child: SignPage8(
                status: signinStatus,
                onPressed: () => Navigator.pop(context),
              ),
            )
        ],
      ),
    );
  }

  ///
  ///
  ///
  ///
  ///

  Future<bool> isEmailExist(String? input) async {
    if (input != null) {
      Map<String, dynamic> result = await GlobalVariables.httpConn
          .post(apiUrl: "/users/validate-duplicate", body: {"email": input});

      if (result['httpConnStatus'] == httpConnStatus.success) {
        return true;
      }
      return false;
    }
    return false;
  }

  bool isWorking = false;

  void changePage(int idx) => setState(() {
        pageIdx = idx;
      });

  Future<bool> createUser(AddUserUserDto userData) async {
    if (!isWorking) {
      isWorking = true;

      Map<String, dynamic> result =
          await GlobalVariables.httpConn.post(apiUrl: "/auth/signup", body: {
        "name": userData.name,
        "nickname": userData.nickname,
        "email": userData.email,
        "password": userData.password,
        "phoneNumber": userData.phoneNumber,
        "profileImageLocation": userData.profileImageLocation,
        "birthdate": DateFormat("yyyy-MM-dd")
            .format(GlobalVariables.defaultDateTime)
            .toString(),
        "location": userData.location,
        "sex": userData.sex.name,
        "job": userData.job,
        "bloodType": userData.bloodType.name,
        "recency": DateFormat("yyyy-MM-dd")
            .format(GlobalVariables.defaultDateTime)
            .toString(),
        "frequency": userData.frequency.toString(),
        "isDonated": userData.isDonated.toString(),
        "isDormant": userData.isDormant.toString(),
        "fbToken": userData.fbToken,
      });

      if (result["httpConnStatus"] == httpConnStatus.success) {
        currUid = result["data"]["id"];
        debugPrint("currUid: $currUid");

        TokenDto? loginResult = await GlobalVariables.httpConn
            .auth(email: userData.email, password: userData.password);

        if (loginResult != null) {
          result = await GlobalVariables.httpConn
              .post(apiUrl: "/users/validate-email");
          if (result["httpConnStatus"] == httpConnStatus.success) {
            isWorking = true;
            return true;
          }
        }
      }
      isWorking = false;
      return false;
    }
    return false;
  }

  Future<bool> checkUserEmailValidation(int code) async {
    Map<String, dynamic> result = await GlobalVariables.httpConn.post(
      apiUrl: "/users/validate-email-send-code",
      queryString: {
        "emailCode": code.toString(),
      },
    );
    return result['httpConnStatus'] == httpConnStatus.success;
  }

  Future<void> changeUserWorker(AddUserUserDto userDto) async {
    changePage(10);
    bool result = await changeUser(userDto);

    if (result) {
      signinStatus = Status.success;
    } else {
      signinStatus = Status.fail;
    }

    changePage(11);
  }

  Future<bool> changeUser(AddUserUserDto userDto) async {
    Map<String, dynamic> result =
        await GlobalVariables.httpConn.patch(apiUrl: "/users/$currUid", body: {
      "name": userDto.name,
      "nickname": userDto.nickname,
      "profileImageLocation": userDto.profileImageLocation,
      "birthdate":
          DateFormat("yyyy-MM-dd").format(userDto.birthdate).toString(),
      "location": userDto.location,
      "sex": userDto.sex.name,
      "job": userDto.job,
      "bloodType": userDto.bloodType.name,
      "isDonated": userDto.isDonated.toString(),
    });

    if (result['httpConnStatus'] == httpConnStatus.success) {
      bool isSuccess = true;

      for (SnsDto i in userDto.sns) {
        Map<String, dynamic> resultSns = await GlobalVariables.httpConn.post(
          apiUrl: "/users/sns",
          body: {
            "userId": currUid.toString(),
            "snsType": i.snsType.name,
            "snsProfile": i.snsProfile,
          },
        );
        if (resultSns['httpConnStatus'] != httpConnStatus.success) {
          isSuccess = false;
        }
      }

      if (isSuccess) return true;
    }

    return false;
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
