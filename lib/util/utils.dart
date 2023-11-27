import 'dart:io';

import 'package:mmd2/data/cache/setting_cache.dart';

class Utils {
  static final settingCache = SettingCache();

  static void launchUrl(String url) {
    Process.start("C:\\Program Files\\Mozilla Firefox\\firefox", ["-private", url]);
    // Process.start(settingCache.browserUrl, [settingCache.argument, url]);
  }
}