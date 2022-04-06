import 'package:app/util/global_variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AddressApiConn {
  Map<int, String> province = {};
  Map<int, String> city = {};

  ///
  ///
  ///
  /// GET
  Future<Map<int, String>> getProvince() async {
    http.Response response = await http.get(
      Uri.parse(GlobalVariables.addressApiUrl + "*00000000"),
    );
    Map<String, dynamic> result =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

    List<dynamic> regcodes = result['regcodes'];
    province = {};

    for (Map<String, dynamic> i in regcodes) {
      province[int.parse(i['code']) ~/ 100000000] = i['name'];
    }

    return province;
  }

  ///
  ///
  ///
  /// GET
  Future<Map<int, String>> getCity({
    required int provinceCode,
  }) async {
    http.Response response = await http.get(
      Uri.parse(GlobalVariables.addressApiUrl + "$provinceCode*000000"),
    );
    Map<String, dynamic> result =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

    List<dynamic> regcodes = result['regcodes'];
    city = {};

    for (Map<String, dynamic> i in regcodes) {
      if ((int.parse(i['code']) ~/ 1000000) % 100 == 0) continue;
      city[(int.parse(i['code']) ~/ 1000000) % 100] = i['name']
          .substring(province[provinceCode]!.length + 1, i['name'].length);
    }

    return city;
  }
}
