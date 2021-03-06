// auth, user 대응

// 유저 정보
import 'package:app/model/association.dto.dart';
import 'package:app/model/post.dto.dart';

class UserDto {
  int uid;
  String name;
  String nickname;
  String email;

  String phoneNumber;
  String profileImageLocation;

  List<SnsDto> sns;

  DateTime birthdate;
  String location;

  Gender sex;
  String job;
  BloodType bloodType;

  bool isDormant;
  bool isDonated;

  DateTime createdDate;
  DateTime modifiedDate;

  // List<AssociationDto> associations;
  // List<int> likedUid;
  // List<PostDto> posts;

  String fbToken;

  UserDto({
    required this.uid,
    required this.name,
    required this.nickname,
    required this.email,
    required this.sns,
    required this.phoneNumber,
    required this.profileImageLocation,
    required this.birthdate,
    required this.location,
    required this.sex,
    required this.job,
    required this.fbToken,
    required this.bloodType,
    required this.isDormant,
    required this.isDonated,
    required this.createdDate,
    required this.modifiedDate,

    // TODO: 임시 (자신의 association, post 확인 시 사용하는 attribute)
    // this.associations = const <AssociationDto>[],
    // this.likedUid = const <int>[],
    // this.posts = const <PostDto>[],
  });
}

// 회원가입 시 필요한 구조
class AddUserUserDto extends UserDto {
  DateTime recency;
  int frequency;
  String password;

  AddUserUserDto({
    required String name,
    required String nickname,
    required String email,
    required String phoneNumber,
    required String profileImageLocation,
    required List<SnsDto> sns,
    required DateTime birthdate,
    required String location,
    required Gender sex,
    required String job,
    required String fbToken,
    required BloodType bloodType,
    required bool isDormant,
    required bool isDonated,
    required DateTime createdDate,
    required DateTime updatedDate,
    required this.recency,
    required this.frequency,
    required this.password,
  }) : super(
          uid: -1,
          name: name,
          nickname: nickname,
          email: email,
          sns: sns,
          phoneNumber: phoneNumber,
          profileImageLocation: profileImageLocation,
          birthdate: birthdate,
          location: location,
          sex: sex,
          job: job,
          fbToken: fbToken,
          bloodType: bloodType,
          isDormant: isDormant,
          isDonated: isDonated,
          createdDate: createdDate,
          modifiedDate: updatedDate,
        );

  @override
  String toString() {
    return """{          
          name: $name,
          nickname: $nickname,
          email: $email,
          recency: $recency,
          frequency: $frequency,
          password: $password,
          sns: $sns,
          phoneNumber: $phoneNumber,
          profileImageLocation: $profileImageLocation,
          birthdate: $birthdate,
          location: $location,
          sex: $sex,
          job: $job,
          fbToken: $fbToken,
          bloodType: $bloodType,
          isDormant: $isDormant,
          isDonated: $isDonated,
          createdDate: $createdDate,
          modifiedDate: $modifiedDate,
        }""";
  }
}

// SNS
class SnsDto {
  SnsType snsType;
  String snsProfile;

  SnsDto({
    required this.snsType,
    required this.snsProfile,
  });

  @override
  String toString() {
    return "{snsType: $snsType, snsProfile: $snsProfile}";
  }
}

// class AddSnsDto {
//   int userId;
//   AddSnsDto({
//     required this.userId,
//     required SnsType snsType,
//     required snsProfile,
//   });
// }

// TODO: 아래 4개 unkonwn 타입 백엔드 요청
enum Gender {
  MALE,
  FEMALE,
}

enum BloodType {
  PLUS_A,
  PLUS_B,
  PLUS_AB,
  PLUS_O,
  MINUS_A,
  MINUS_B,
  MINUS_AB,
  MINUS_O,
}

Map<BloodType, String> bloodTypeLabel = const {
  BloodType.PLUS_A: "RH+ A",
  BloodType.PLUS_B: "RH+ B",
  BloodType.PLUS_AB: "RH+ AB",
  BloodType.PLUS_O: "RH+ O",
  BloodType.MINUS_A: "RH- A",
  BloodType.MINUS_B: "RH- B",
  BloodType.MINUS_AB: "RH- AB",
  BloodType.MINUS_O: "RH- O",
};

enum SnsType {
  FACEBOOK,
  INSTAGRAM,
  KAKAO,
  TWITTER,
}

enum Auth {
  ROLE_USER,
  ROLE_NEED_EMAIL,
  ROLE_ADMIN,
}
