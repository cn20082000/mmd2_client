import 'package:flutter/material.dart';

class SectionScreen extends StatefulWidget {
  final Widget? appBar;
  final Widget? body;
  final Widget? floatingButton;

  const SectionScreen({super.key, this.appBar, this.body, this.floatingButton});

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56),
              child: widget.appBar,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                clipBehavior: Clip.hardEdge,
                child: widget.body,
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(16),
          child: widget.floatingButton,
        )
      ],
    );
  }
}
