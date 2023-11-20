import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/loading/view/loading_controller.dart';

class LoadingView extends StatefulWidget {
  final LoadingController controller;
  final Widget Function(bool loading) builder;

  const LoadingView({super.key, required this.controller, required this.builder});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState<T extends LoadingView> extends State<T> {
  LoadingController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    widget.controller.listener = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(controller.loading);
  }
}
