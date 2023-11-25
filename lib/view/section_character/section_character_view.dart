import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/section_character/all_world/all_world_view.dart';

class SectionCharacterView extends StatelessWidget {
  const SectionCharacterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(builder: (_) => const AllWorldView());
  }
}
