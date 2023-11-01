import 'package:flutter/material.dart';

class SectionNavigator extends StatefulWidget {
  final Widget Function(BuildContext) builder;
  const SectionNavigator({super.key, required this.builder});

  @override
  State<SectionNavigator> createState() => _SectionNavigatorState();
}

class _SectionNavigatorState extends State<SectionNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: widget.builder, settings: settings);
      },
    );
  }
}
