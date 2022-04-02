// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import 'package:jwt_decode/jwt_decode.dart';

// Future<void> doLogin({
//   required String userid,
//   required String userpw,
// }) async {
//   var body = convert.json.encode(
//     {"email": userid, "password": userpw},
//   );

//   Map<String, String> headers = {
//     HttpHeaders.contentTypeHeader: 'application/json',
//     HttpHeaders.acceptHeader: 'application/json',
//   };

//   http.Response response = await http.post(
//     Uri.parse(GlobalVariables.baseurl + "/auth"),
//     body: body,
//     headers: headers,
//   );

//   Map<String, dynamic> result = convert.jsonDecode(response.body);

//   if (result.keys.contains("token")) {
//     Map<String, dynamic> payload = Jwt.parseJwt(result['token']);
//     GlobalVariables.userIdx = int.parse(payload['sub']);

//     response = await http.get(Uri.parse(GlobalVariables.baseurl +
//         "/users?userId=" +
//         GlobalVariables.userIdx.toString()));

//     result = convert.jsonDecode(response.body);

//     if (result.keys.contains("data")) {
//       // print(response.body);
//       Navigator.pushReplacementNamed(context, "/splash");
//       return;
//     }
//   }

//   isLoginFailed = true;
//   setState(() {});
// }
