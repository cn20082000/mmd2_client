import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/section_song/all_song/all_song_view.dart';

class SectionSongView extends StatelessWidget {
  const SectionSongView({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(builder: (_) => const AllSongView());
  }
}
