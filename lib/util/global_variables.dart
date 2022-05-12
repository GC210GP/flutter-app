import 'package:app/model/person.dto.dart';
import 'package:app/util/chat/chat_data.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:flutter/material.dart';

class GlobalVariables {
  static const String baseurl =
      "http://blooddonationnew-env.eba-zyvef2nw.ap-northeast-2.elasticbeanstalk.com";

  static double radius = 12.5;

  static int badgetCount = 0;

  // User 관련 상태
  static String savedEmail = "";
  static String fcmToken = "";
  static UserDto? userDto;

  static BuildContext? currentContext;

  // TODO: 바꾸기
  static String defaultImgUrl =
      "https://www.mein-maler.de/wp-content/uploads/2021/04/anonym.png";

  /// - *00000000 모든 특별시도
  /// - 41*000000 경기도 시군구
  static String addressApiUrl =
      "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes?regcode_pattern=";

  // Refactoring
  static HttpConn httpConn = HttpConn();

  static String emailQuery(String? name) =>
      'subject=[더블디] ${name == null ? "" : name + '님 '}계정 및 기타문의&body=카테고리: [ 계정 | 장애 | 건의사항 | 기타 ]\n문의내용:&cc=uhug@gachon.ac.kr, 2rhgywls@gachon.ac.kr, cyc0227@gachon.ac.kr';
  static String emailAccountQuery =
      'subject=[더블디] 계정 문의&body=카테고리: [ 계정 ]\n이름:\n가입 이메일:\n&cc=uhug@gachon.ac.kr, 2rhgywls@gachon.ac.kr, cyc0227@gachon.ac.kr';
}
