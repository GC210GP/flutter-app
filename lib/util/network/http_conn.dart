import 'dart:io';
import 'package:app/model/fcm.dto.dart';
import 'package:app/model/person.dto.dart';
import 'package:app/model/token.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/secret.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:jwt_decode/jwt_decode.dart';

enum httpConnStatus {
  success,
  badRequest,
  unauthorized,
  internalServerError,
  payloadTooLarge,
  unknownError,
}

class HttpConn {
  final Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: "",
  };

  ///
  ///
  ///
  /// GET
  Future<Map<String, dynamic>> get({
    required String apiUrl,
    Map<String, dynamic>? queryString,
  }) async {
    http.Response response = await http.get(
      Uri.parse(GlobalVariables.baseurl + apiUrl + queryBuilder(queryString)),
      headers: _headers,
    );
    return resultBuilder(response);
  }

  ///
  ///
  ///
  /// POST
  Future<Map<String, dynamic>> post({
    required String apiUrl,
    Map<String, String>? queryString,
    Map<String, String>? body,
  }) async {
    var _body = convert.json.encode(body);
    http.Response response = await http.post(
      Uri.parse(GlobalVariables.baseurl + apiUrl + queryBuilder(queryString)),
      headers: _headers,
      body: _body,
    );
    return resultBuilder(response);
  }

  ///
  ///
  ///
  /// POST
  Future<Map<String, dynamic>> fbPost({
    required FcmDto sendData,
  }) async {
    var _body = convert.json.encode(Secret.buildFbBody(sendData));
    http.Response response = await http.post(
      Uri.parse(Secret.fbBaseUrl),
      headers: Secret.fbHeader,
      body: _body,
    );
    return resultBuilder(response);
  }

  ///
  ///
  ///
  /// DELETE
  Future<Map<String, dynamic>> delete({
    required String apiUrl,
    Map<String, String>? queryString,
    Map<String, String>? body,
  }) async {
    var _body = convert.json.encode(body);
    http.Response response = await http.delete(
      Uri.parse(GlobalVariables.baseurl + apiUrl + queryBuilder(queryString)),
      headers: _headers,
      body: _body,
    );
    return resultBuilder(response);
  }

  ///
  ///
  ///
  /// PATCH
  Future<Map<String, dynamic>> patch({
    required String apiUrl,
    Map<String, String>? queryString,
    Map<String, String>? body,
  }) async {
    var _body = convert.json.encode(body);
    http.Response response = await http.patch(
      Uri.parse(GlobalVariables.baseurl + apiUrl + queryBuilder(queryString)),
      headers: _headers,
      body: _body,
    );
    return resultBuilder(response);
  }

  ///
  ///
  ///
  /// PUT
  Future<Map<String, dynamic>> put({
    required String apiUrl,
    Map<String, String>? queryString,
    Map<String, String>? fields,
    List<File>? files,
  }) async {
    http.MultipartRequest request = http.MultipartRequest(
      'PUT',
      Uri.parse(GlobalVariables.baseurl + apiUrl + queryBuilder(queryString)),
    );

    // 파일 추가
    if (files != null) {
      int i = 0;
      for (File f in files) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'data',
            f.readAsBytesSync(),
            filename: "file$i.jpg",
          ),
        );
        i++;
      }
    }

    // 인증 추가
    request.headers[HttpHeaders.authorizationHeader] =
        _headers[HttpHeaders.authorizationHeader] ?? "";

    // fields 추가
    if (fields != null) {
      List<String> keys = fields.keys.toList();
      List<String> values = fields.values.toList();
      for (int i = 0; i < keys.length; i++) {
        request.fields[keys[i]] = values[i];
      }
    }

    ///
    ///
    ///
    // 결과값 정리
    http.StreamedResponse response = await request.send();
    Map<String, dynamic> result = {};

    result["status"] = response.statusCode;

    if (response.statusCode < 400) {
      result["httpConnStatus"] = httpConnStatus.success;
      String rawBody = await response.stream.bytesToString();
      List<dynamic> fileUrlList = [];
      if (rawBody[0] == "[") {
        fileUrlList = convert.jsonDecode(rawBody);
      } else {
        fileUrlList = [rawBody];
      }

      result["files"] = fileUrlList;
    } else if (response.statusCode == 400) {
      result["httpConnStatus"] = httpConnStatus.badRequest;
    } else if (response.statusCode == 401) {
      result["httpConnStatus"] = httpConnStatus.unauthorized;
    } else if (response.statusCode == 500) {
      result["httpConnStatus"] = httpConnStatus.internalServerError;
    } else if (response.statusCode == 413) {
      result["httpConnStatus"] = httpConnStatus.payloadTooLarge;
    } else {
      result["httpConnStatus"] = httpConnStatus.unknownError;
    }

    return result;
  }

  ///
  ///
  ///

  ///
  ///
  ///
  /// 인증
  Future<TokenDto?> auth({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> result = await post(
      apiUrl: '/auth',
      body: {"email": email, "password": password},
    );

    if (result['httpConnStatus'] == httpConnStatus.success) {
      Map<String, dynamic> payload = Jwt.parseJwt(result['token']);

      int userIdx = int.parse(payload['sub']);
      DateTime exp = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      Auth auth = Auth.ROLE_NEED_EMAIL;
      for (Auth i in Auth.values) {
        if (i.toString() == payload['auth']) auth = i;
      }

      _headers[HttpHeaders.authorizationHeader] = "Bearer " + result["token"];

      return TokenDto(
        token: result['token'],
        auth: auth,
        exp: exp,
        id: userIdx,
      );
    }
    return null;
  }

  ///
  ///
  ///
  /// 결과를 Map 형태로 리턴
  Map<String, dynamic> resultBuilder(http.Response response) {
    Map<String, dynamic> result = {};
    if (convert.utf8.decode(response.bodyBytes).isNotEmpty) {
      result = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
    }

    if (response.statusCode < 400) {
      result["httpConnStatus"] = httpConnStatus.success;
    } else if (response.statusCode == 400) {
      result["httpConnStatus"] = httpConnStatus.badRequest;
    } else if (response.statusCode == 401) {
      result["httpConnStatus"] = httpConnStatus.unauthorized;
    } else if (response.statusCode == 500) {
      result["httpConnStatus"] = httpConnStatus.internalServerError;
    } else if (response.statusCode == 413) {
      result["httpConnStatus"] = httpConnStatus.payloadTooLarge;
    } else {
      result["httpConnStatus"] = httpConnStatus.unknownError;
    }

    return result;
  }

  ///
  ///
  ///
  /// Map 형태의 query를 queryString으로 변환
  String queryBuilder(Map<String, dynamic>? queryString) {
    String query = "";
    if (queryString != null) {
      query = "?";
      List<String> keys = queryString.keys.toList();
      List<dynamic> values = queryString.values.toList();
      for (int i = 0; i < keys.length; i++) {
        query += keys[i] + "=" + values[i].toString();
      }
    }
    return query;
  }
}
