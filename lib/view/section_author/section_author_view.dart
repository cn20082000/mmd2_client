import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/section_author/all_author/all_author_view.dart';

class SectionAuthorView extends StatelessWidget {
  const SectionAuthorView({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(builder: (_) => const AllAuthorView());
  }
}
