import 'package:app/model/person.dto.dart';
import 'package:app/util/network/http_conn.dart';

class GlobalVariables {
  static const String baseurl =
      "http://blooddonationnew-env.eba-zyvef2nw.ap-northeast-2.elasticbeanstalk.com";

  static int userIdx = 1;

  static double radius = 12.5;

  static int badgetCount = 0;

  static List<UserDto> suggestionList = [];

  // TODO: 바꾸기
  static String defaultImgUrl =
      "https://www.mein-maler.de/wp-content/uploads/2021/04/anonym.png";

  /// - *00000000 모든 특별시도
  /// - 41*000000 경기도 시군구
  static String addressApiUrl =
      "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes?regcode_pattern=";

  // Refactoring
  static HttpConn httpConn = HttpConn();
}
