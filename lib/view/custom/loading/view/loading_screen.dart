import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/loading/view/loading_controller.dart';

class LoadingScreen extends StatefulWidget {
  final LoadingController controller;
  final Widget? child;

  const LoadingScreen({super.key, required this.controller, this.child});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LoadingController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    widget.controller.listener = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.loading) const LinearProgressIndicator(minHeight: 4),
        if (widget.child != null) Expanded(child: widget.child!),
      ],
    );
  }
}
