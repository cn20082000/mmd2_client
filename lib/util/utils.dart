import 'dart:io';

class Utils {
  static void launchUrl(String url) {
    Process.start("C:\\Program Files\\Mozilla Firefox\\firefox", ["-private", url]);
  }
}