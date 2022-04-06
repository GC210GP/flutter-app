import 'package:app/model/person.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/address_api_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/signup/signup.view.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/dropdown_button.dart';
import 'package:app/widget/input_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignPage5 extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onBackPressed;

  const SignPage5({
    Key? key,
    this.onPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<SignPage5> createState() => _SignPage5State();
}

class _SignPage5State extends State<SignPage5> {
  late AddressApiConn addressApiConn;

  @override
  void initState() {
    addressApiConn = AddressApiConn();
    addressApiConn.getProvince().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 70.0, bottom: 50.0),
        children: [
          Center(
            child: SizedBox(
              width: 250,
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
                      "거의 다왔어요!",
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
                      "추가 정보를 입력해주세요",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h3,
                        color: DDColor.fontColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50.0),

                  Center(
                    child: Text(
                      "혈액형",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  BloodTypePicker(),

                  const SizedBox(height: 20.0),

                  Center(
                    child: Text(
                      "헌혈유무",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  BinaryPicker(),

                  const Divider(
                    height: 60.0,
                  ),

                  Center(
                    child: Text(
                      "태어난 연도",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  YearPicker(),

                  const SizedBox(height: 20.0),

                  Center(
                    child: Text(
                      "성별",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  GenderPicker(),

                  const SizedBox(height: 20.0),

                  Center(
                    child: Text(
                      "직업",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  DDTextField(),

                  const SizedBox(height: 20.0),

                  Center(
                    child: Text(
                      "거주지",
                      style: TextStyle(
                        fontFamily: DDFontFamily.nanumSR,
                        fontWeight: DDFontWeight.extraBold,
                        fontSize: DDFontSize.h4,
                        color: DDColor.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  DDDropdownButton(
                    disabledHint: Text("광역시도..."),
                    items: [...addressApiConn.province.values],
                    onChanged: (value) async {
                      if (value != null) {
                        int provinceCode =
                            addressApiConn.province.keys.toList()[addressApiConn
                                .province.values
                                .toList()
                                .indexOf(value)];

                        await addressApiConn.getCity(
                            provinceCode: provinceCode);

                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  DDDropdownButton(
                    disabledHint: Text("시군구..."),
                    items: [...addressApiConn.city.values],
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 50.0),

                  Center(
                    child: DDButton(
                      width: 80,
                      label: "확인",
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
// 날짜 피커
class YearPicker extends StatefulWidget {
  const YearPicker({Key? key}) : super(key: key);

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  FixedExtentScrollController controller = FixedExtentScrollController();
  int birth = DateTime.now().year;

  @override
  void initState() {
    controller.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(GlobalVariables.radius),
        color: DDColor.widgetBackgroud,
        child: Text(
          birth.toString(),
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h4,
            color: DDColor.fontColor,
          ),
        ),
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 300,
                  child: CupertinoPicker(
                      scrollController: controller,
                      itemExtent: 40.0,
                      onSelectedItemChanged: (index) {
                        birth = DateTime.now().year - index;
                        setState(() {});
                      },
                      diameterRatio: 1.1,
                      useMagnifier: true,
                      magnification: 1.2,
                      backgroundColor: Colors.white,
                      offAxisFraction: 0.0,
                      children: [
                        for (int i = DateTime.now().year; i >= 1900; i--)
                          Container(
                            alignment: Alignment.center,
                            child: Text('$i'),
                          ),
                      ]),
                );
              });
          await Future.delayed(const Duration(milliseconds: 250));

          controller.animateToItem(
            DateTime.now().year - birth,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 500),
          );
        },
      ),
    );
  }
}

///
///
///
///
///

class BinaryPicker extends StatefulWidget {
  const BinaryPicker({Key? key}) : super(key: key);

  @override
  State<BinaryPicker> createState() => _BinaryPickerState();
}

class _BinaryPickerState extends State<BinaryPicker> {
  String binaryLabel = "예";
  bool binary = true;

  List<String> binaryLabels = ["예", "아니오"];
  List<bool> genders = [true, false];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(GlobalVariables.radius),
        color: DDColor.widgetBackgroud,
        child: Text(
          binaryLabel,
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h4,
            color: DDColor.fontColor,
          ),
        ),
        onPressed: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('\n자신의 성별을 선택하세요\n'),
              // message: const Text(''),
              actions: <CupertinoActionSheetAction>[
                for (int i = 0; i < binaryLabels.length; i++)
                  CupertinoActionSheetAction(
                    child: Text(binaryLabels[i]),
                    onPressed: () {
                      binary = genders[i];
                      binaryLabel = binaryLabels[i];
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GenderPicker extends StatefulWidget {
  const GenderPicker({Key? key}) : super(key: key);

  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  String genderLabel = "남자";
  Gender gender = Gender.MALE;

  List<String> genderLabels = ["남자", "여자"];
  List<Gender> genders = [Gender.MALE, Gender.FEMALE];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(GlobalVariables.radius),
        color: DDColor.widgetBackgroud,
        child: Text(
          genderLabel,
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h4,
            color: DDColor.fontColor,
          ),
        ),
        onPressed: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('\n자신의 성별을 선택하세요\n'),
              // message: const Text(''),
              actions: <CupertinoActionSheetAction>[
                for (int i = 0; i < genderLabels.length; i++)
                  CupertinoActionSheetAction(
                    child: Text(genderLabels[i]),
                    onPressed: () {
                      gender = genders[i];
                      genderLabel = genderLabels[i];
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BloodTypePicker extends StatefulWidget {
  const BloodTypePicker({Key? key}) : super(key: key);

  @override
  State<BloodTypePicker> createState() => _BloodTypePickerState();
}

class _BloodTypePickerState extends State<BloodTypePicker> {
  String bloodTypeLabel = "A형 RH+";
  BloodType bloodType = BloodType.PLUS_A;

  List<String> bloodTypeLabels = [
    "A형 RH+",
    "B형 RH+",
    "O형 RH+",
    "AB형 RH+",
    "A형 RH-",
    "B형 RH-",
    "O형 RH-",
    "AB형 RH-",
  ];
  List<BloodType> bloodTypes = [
    BloodType.PLUS_A,
    BloodType.PLUS_B,
    BloodType.PLUS_O,
    BloodType.PLUS_AB,
    BloodType.MINUS_A,
    BloodType.MINUS_B,
    BloodType.MINUS_O,
    BloodType.MINUS_AB,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(GlobalVariables.radius),
        color: DDColor.widgetBackgroud,
        child: Text(
          bloodTypeLabel,
          style: TextStyle(
            fontFamily: DDFontFamily.nanumSR,
            fontWeight: DDFontWeight.extraBold,
            fontSize: DDFontSize.h4,
            color: DDColor.fontColor,
          ),
        ),
        onPressed: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('\n자신의 혈액형을 선택하세요\n'),
              // message: const Text(''),
              actions: <CupertinoActionSheetAction>[
                for (int i = 0; i < bloodTypeLabels.length; i++)
                  CupertinoActionSheetAction(
                    child: Text(bloodTypeLabels[i]),
                    onPressed: () {
                      bloodType = bloodTypes[i];
                      bloodTypeLabel = bloodTypeLabels[i];
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
