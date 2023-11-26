import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/section_video/query_video/query_video_view.dart';

class SectionVideoView extends StatelessWidget {
  const SectionVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(builder: (_) => const QueryVideoView());
  }
}
