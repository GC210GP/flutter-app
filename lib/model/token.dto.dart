// token 대응

import 'package:app/model/person.dto.dart';

class TokenDto {
  String token;
  int id;
  DateTime exp;
  Auth auth;

  TokenDto({
    required this.token,
    required this.auth,
    required this.exp,
    required this.id,
  });
}
