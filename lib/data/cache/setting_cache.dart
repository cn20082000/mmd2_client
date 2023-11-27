import 'package:mmd2/data/cache/base_cache.dart';

class SettingCache extends BaseCache {
  String get browserUrl {
    return pref.getString(CacheConst.browserUrl) ?? "";
  }

  set browserUrl(String value) {
    pref.setString(CacheConst.browserUrl, value);
  }

  String get argument {
    return pref.getString(CacheConst.argument) ?? "";
  }

  set argument(String value) {
    pref.setString(CacheConst.argument, value);
  }
}