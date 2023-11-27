import 'package:flutter/material.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/data/cache/base_cache.dart';
import 'package:mmd2/data/client/system_client.dart';
import 'package:mmd2/util/desktop_scroll_behavior.dart';
import 'package:mmd2/view/home_view.dart';

void main() async {
  await Future.wait([
    _getSystem(),
    BaseCache.initialPref(),
  ]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    scrollBehavior: DesktopScrollBehavior(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const HomeView(),
  ));
}

Future<void> _getSystem() async {
  final systemClient = SystemClient();

  final response = await systemClient.getSystem();

  if (response?.data != null) {
    App.additionHeader.clear();
    App.additionHeader.addAll(response?.data?.additionHeaders ?? {});
  }
}
