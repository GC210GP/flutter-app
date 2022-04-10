import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
const String LOG = "PrefManager:: ";

enum PrefItem { token }

class PreferenceManager {
  // Singleton
  PreferenceManager._();
  static final PreferenceManager _instance = PreferenceManager._();
  static PreferenceManager get instance => _instance;

  late SharedPreferences _prefs;

  bool _isInit = false;

  String? _token;

  // 초기화
  Future<void> init() async {
    debugPrint("$LOG init.");
    _isInit = true;
    _prefs = await SharedPreferences.getInstance();

    // 저장된 값 불러오기 load()
    _token = _prefs.getString(PrefItem.token.name);

    debugPrint("$LOG init done.");
  }

  ///
  ///
  ///
  ///
  // CRUD

  /// ### CREATE
  void createPref({
    required String token,
  }) {
    checkInit();

    debugPrint("$LOG Create Start");
    _prefs.setString(PrefItem.token.name, token);
    _token = token;
    debugPrint("$LOG Create End");
  }

  ///
  /// ### READ
  String? readSavedToken() => _token;

  ///
  /// ### UPDATE
  void updateSavedToken({
    required String token,
  }) {
    checkInit();

    debugPrint("$LOG Update start");

    _prefs.setString(PrefItem.token.name, token);
    _token = token;

    debugPrint("$LOG Update done");
  }

  ///
  /// ### DELETE
  void deleteSavedToken({
    required int index,
  }) {
    checkInit();
    debugPrint("$LOG Delete start");

    _prefs.remove(PrefItem.token.name);
    _token = null;

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
