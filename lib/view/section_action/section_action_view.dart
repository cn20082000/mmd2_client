import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/section_action/all_action/all_action_view.dart';

class SectionActionView extends StatelessWidget {
  const SectionActionView({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(builder: (_) => const AllActionView());
  }
}
