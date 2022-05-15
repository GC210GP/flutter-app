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
  final String nickname;
  final String email;

  final Function({
    required BloodType bloodType,
    required bool isDonated,
    required DateTime birthdate,
    required Gender sex,
    required String job,
    required String address,
  })? onPressed;
  final VoidCallback? onBackPressed;

  const SignPage5({
    Key? key,
    required this.nickname,
    required this.email,
    this.onPressed,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<SignPage5> createState() => _SignPage5State();
}

class _SignPage5State extends State<SignPage5> {
  late AddressApiConn addressApiConn;
  BloodType bloodType = BloodType.PLUS_A;
  bool isDonated = false;
  DateTime birthdate = DateTime(DateTime.now().year);
  Gender sex = Gender.MALE;
  String job = "";
  String addressProvince = "";
  String addressCity = "";

  double pageOpacity = 0.0;
  bool isError = false;

  @override
  void initState() {
    addressApiConn = AddressApiConn();
    addressApiConn.getProvince().then((value) => setState(() {}));

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
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ProfileItem(
                        nickname: widget.nickname,
                        email: widget.email,
                        imgUrl: GlobalVariables.defaultImgUrl,
                      ),
                    ),

                    const SizedBox(height: 25.0),

                    Center(
                      child: Text(
                        "거의 다왔어요!",
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
                        "추가 정보를 입력해주세요",
                        textAlign: TextAlign.center,
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
                    BloodTypePicker(
                      onChanged: ((value) => bloodType = value),
                    ),

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
                    BinaryPicker(
                      onChanged: (value) => isDonated = value,
                    ),

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
                    YearPicker(
                        onChanged: (value) => birthdate = DateTime(value)),

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
                    GenderPicker(onChanged: (value) => sex = value),

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
                    DDTextField(onChanged: (p0) => job = p0),

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
                      disabledHint: const Text("광역시도..."),
                      items: [...addressApiConn.province.values],
                      onChanged: (value) async {
                        if (value != null) {
                          int provinceCode =
                              addressApiConn.province.keys.toList()[
                                  addressApiConn.province.values
                                      .toList()
                                      .indexOf(value)];

                          await addressApiConn.getCity(
                              provinceCode: provinceCode);

                          addressProvince = value;
                          addressCity = [...addressApiConn.city.values][0];

                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    DDDropdownButton(
                      disabledHint: const Text("시군구..."),
                      labelText: addressCity,
                      items: [...addressApiConn.city.values],
                      onChanged: (value) {
                        if (value != null) {
                          addressCity = value;
                        }
                      },
                    ),

                    const SizedBox(height: 20.0),

                    if (isError)
                      Center(
                        child: Text(
                          "모든 항목을 빠짐없이 입력해주세요!",
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
                        width: 80,
                        label: "확인",
                        onPressed: () {
                          if (widget.onPressed != null) {
                            if ("$addressProvince $addressCity".isNotEmpty &&
                                job.isNotEmpty) {
                              widget.onPressed!(
                                address: "$addressProvince $addressCity",
                                birthdate: birthdate,
                                bloodType: bloodType,
                                isDonated: isDonated,
                                job: job,
                                sex: sex,
                              );
                            } else {
                              isError = true;
                            }
                            setState(() {});
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
  final Function(int value)? onChanged;

  const YearPicker({
    Key? key,
    this.onChanged,
  }) : super(key: key);

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
    return SizedBox(
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

                        if (widget.onChanged != null) {
                          widget.onChanged!(birth);
                        }

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
  final Function(bool value)? onChanged;

  const BinaryPicker({
    Key? key,
    this.onChanged,
  }) : super(key: key);

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

                      if (widget.onChanged != null) {
                        widget.onChanged!(binary);
                      }

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
  final Function(Gender value)? onChanged;

  const GenderPicker({
    Key? key,
    this.onChanged,
  }) : super(key: key);

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

                      if (widget.onChanged != null) {
                        widget.onChanged!(gender);
                      }

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
  final Function(BloodType value)? onChanged;

  const BloodTypePicker({
    Key? key,
    this.onChanged,
  }) : super(key: key);

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

                      if (widget.onChanged != null) {
                        widget.onChanged!(bloodType);
                      }

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
