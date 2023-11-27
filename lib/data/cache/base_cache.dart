import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseCache {
  static late SharedPreferences _pref;

  @protected
  SharedPreferences get pref => _pref;

  static Future<void> initialPref() async {
    _pref = await SharedPreferences.getInstance();
  }
}

class CacheConst {
  static const String browserUrl = "cacheBrowserUrl";
  static const String argument = "cacheArgument";
}
