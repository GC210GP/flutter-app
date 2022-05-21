import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
const String LOG = "PrefManager:: ";

enum PrefItem {
  token,
  savedEmail,
}

class PreferenceManager {
  // Singleton
  PreferenceManager._();
  static final PreferenceManager _instance = PreferenceManager._();
  static PreferenceManager get instance => _instance;

  late SharedPreferences _prefs;

  bool _isInit = false;

  // Items
  String? _token;
  String? _savedEmail;

  // 초기화
  Future<void> init() async {
    debugPrint("$LOG init.");
    _isInit = true;
    _prefs = await SharedPreferences.getInstance();

    // 저장된 값 불러오기 load()
    _token = _prefs.getString(PrefItem.token.name);
    _savedEmail = _prefs.getString(PrefItem.savedEmail.name);

    debugPrint("$LOG init done.");
  }

  ///
  ///
  ///
  ///
  // CRUD

  /// ### CREATE
  void createPref({
    String? token,
    String? savedEmail,
  }) {
    checkInit();

    debugPrint("$LOG Create Start");

    if (token != null) {
      _prefs.setString(PrefItem.token.name, token);
      _token = token;
    }
    if (savedEmail != null) {
      _prefs.setString(PrefItem.savedEmail.name, savedEmail);
      _savedEmail = savedEmail;
    }

    debugPrint("$LOG Create End");
  }

  ///
  /// ### READ
  String? read(PrefItem target) {
    if (target == PrefItem.token) {
      return _token;
    }
    if (target == PrefItem.savedEmail) {
      return _savedEmail;
    }
    return null;
  }

  ///
  /// ### UPDATE
  void update({
    String? token,
    String? savedEmail,
  }) {
    checkInit();

    debugPrint("$LOG Update start");

    if (token != null) {
      _prefs.setString(PrefItem.token.name, token);
      _token = token;
    }
    if (savedEmail != null) {
      _prefs.setString(PrefItem.savedEmail.name, savedEmail);
      _savedEmail = savedEmail;
    }

    debugPrint("$LOG Update done");
  }

  ///
  /// ### DELETE
  void delete({
    required PrefItem target,
  }) {
    checkInit();
    debugPrint("$LOG Delete start");

    if (target == PrefItem.token) {
      _prefs.remove(PrefItem.token.name);
      _token = null;
    }
    if (target == PrefItem.savedEmail) {
      _prefs.remove(PrefItem.savedEmail.name);
      _savedEmail = null;
    }

    debugPrint("$LOG Delete done");
  }

  ///
  ///
  ///
  ///
  // 기타 함수

  /// ### Reset Preferences
  ///  - shared preferences 값 초기화
  Future<void> resetPrefs() async {
    checkInit();
    debugPrint("$LOG Reset start");
    await _prefs.remove("token");
    debugPrint("$LOG Reset done.");
  }

  /// ### Check Init
  ///  - 초기화 상태 확인
  ///  - init() 함수 호출 여부 확인
  void checkInit() {
    if (!_isInit) {
      throw Exception("Please init() before use PreferenceManager.");
    }
  }
}
