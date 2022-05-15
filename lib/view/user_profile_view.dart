import 'package:app/model/like.dto.dart';
import 'package:app/model/person.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/app_bar.dart';

class UserProfileView extends StatefulWidget {
  final String title;
  final int toId;
  const UserProfileView({Key? key, required this.title, required this.toId})
      : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  bool isLoaded = false;

  late UserDto toUser;
  bool isLiked = false;
  List<List<String>> detailedInfo = [];

  @override
  void initState() {
    GlobalVariables.httpConn.get(
      apiUrl: "/users",
      queryString: {"userId": widget.toId},
    ).then((result) {
      if (result['httpConnStatus'] == httpConnStatus.success) {
        late Gender sex;
        late BloodType bloodType;

        for (Gender i in Gender.values) {
          i.toString() == "Gender.${result['data']['sex']}" ? sex = i : null;
        }
        for (BloodType i in BloodType.values) {
          i.toString() == "BloodType.${result['data']['bloodType']}"
              ? bloodType = i
              : null;
        }

        GlobalVariables.httpConn.get(
          apiUrl: "/users/sns",
          queryString: {"userId": 17},
        ).then((resultSns) {
          if (resultSns['httpConnStatus'] == httpConnStatus.success) {
            List<SnsDto> snslists = [];

            for (Map<String, dynamic> snsList in resultSns['data']) {
              late SnsType snsType;

              for (SnsType i in SnsType.values) {
                i.toString() == "SnsType.${snsList['snsType']}"
                    ? snsType = i
                    : null;
              }

              snslists.add(
                SnsDto(snsType: snsType, snsProfile: snsList['profile']),
              );
            }

            toUser = UserDto(
              uid: result['data']['id'],
              name: result['data']['name'],
              nickname: result['data']['nickname'],
              email: result['data']['email'],
              sns: snslists,
              phoneNumber: result['data']['phoneNumber'],
              profileImageLocation: result['data']['profileImageLocation'],
              birthdate: DateTime.parse(result['data']['birthdate']),
              location: result['data']['location'],
              sex: sex,
              job: result['data']['job'],
              fbToken: result['data']['fbToken'],
              bloodType: bloodType,
              isDormant: result['data']['isDormant'],
              isDonated: result['data']['isDonated'],
              createdDate: DateTime.parse(result['data']['createdDate']),
              modifiedDate: DateTime.parse(result['data']['modifiedDate']),
            );

            for (LikeDto l in GlobalVariables.likedList) {
              if (l.userTo == toUser.uid) {
                isLiked = true;
                break;
              }
            }

            detailedInfo = [
              ["혈액형", bloodTypeLabel[toUser.bloodType] ?? "unknown"],
              ["직업", toUser.job],
              ["위치", toUser.location]
            ];

            //

            isLoaded = true;
            setState(() {});
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: DDAppBar(
          context,
          title: widget.title,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLoaded)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(GlobalVariables.radius),
                        child: Image.network(
                          toUser.profileImageLocation,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DDPageTitleWidget(
                                title: toUser.nickname,
                                margin: const EdgeInsets.all(0.0),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  isLiked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                  size: 30,
                                  color:
                                      isLiked ? DDColor.primary : DDColor.grey,
                                ),
                                onPressed: () => setLike(
                                    isLike: isLiked, userTo: toUser.uid),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: DDColor.disabled,
                        height: 0.5,
                      ),
                      const SizedBox(height: 20),
                      for (List<String> items in detailedInfo)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              items[0],
                              style: TextStyle(
                                fontFamily: DDFontFamily.nanumSR,
                                color: DDColor.grey,
                                fontSize: DDFontSize.h4,
                                fontWeight: DDFontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.5),
                            Text(
                              items[1],
                              style: TextStyle(
                                fontFamily: DDFontFamily.nanumSR,
                                color: DDColor.fontColor,
                                fontSize: DDFontSize.h3,
                                fontWeight: DDFontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        )
                    ],
                  ),
                )

              ///
              ///
              ///
              // User data 비정상 로드
              else
                Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 100.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 7.5,
                      color: DDColor.primary.shade600,
                      backgroundColor: DDColor.disabled,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  bool isSetLikeWorking = false;
  Future<void> setLike({required bool isLike, required int userTo}) async {
    if (!isSetLikeWorking) {
      isSetLikeWorking = true;
      if (isLiked) {
        int did = -1;

        for (int l = 0; l < GlobalVariables.likedList.length; l++) {
          if (GlobalVariables.likedList[l].userTo == userTo) {
            did = GlobalVariables.likedList[l].lid;
            GlobalVariables.likedList.removeAt(l);
            break;
          }
        }

        Map<String, dynamic> result = await GlobalVariables.httpConn.delete(
          apiUrl: "/likes/$did",
        );

        if (result['httpConnStatus'] == httpConnStatus.success) {
          isLiked = false;
          setState(() {});
        }
      } else {
        Map<String, dynamic> result = await GlobalVariables.httpConn.post(
          apiUrl: "/likes",
          body: {
            "userIdFrom": GlobalVariables.userDto!.uid,
            "userIdTo": userTo
          },
        );

        if (result['httpConnStatus'] == httpConnStatus.success) {
          GlobalVariables.likedList.add(
            LikeDto(userTo: userTo, lid: result['likedId']),
          );

          isLiked = true;
          setState(() {});
        }
      }
      isSetLikeWorking = false;
    }
  }
}
