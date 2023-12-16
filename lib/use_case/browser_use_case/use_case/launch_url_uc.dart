import 'dart:io';

class LaunchUrlUC {
  void invoke(String? url) {
    Process.start("C:\\Program Files\\Mozilla Firefox\\firefox", ["-private", url ?? ""]);
  }
}