import 'package:flutter/material.dart';
import 'package:mmd2/view/action/action_view.dart';
import 'package:mmd2/view/author/author_view.dart';
import 'package:mmd2/view/character/character_view.dart';
import 'package:mmd2/view/custom/navigation_button.dart';
import 'package:mmd2/view/song/song_view.dart';
import 'package:mmd2/view/video/video_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          Column(
            children: [
              NavigationButton(
                icon: Icons.movie,
                tooltip: "Videos",
                highlight: index == 0,
                onPressed: () {
                  if (index != 0) setState(() => index = 0);
                },
              ),
              NavigationButton(
                icon: Icons.video_camera_front,
                tooltip: "Authors",
                highlight: index == 1,
                onPressed: () {
                  if (index != 1) setState(() => index = 1);
                },
              ),
              NavigationButton(
                icon: Icons.music_note,
                tooltip: "Songs & Producers",
                highlight: index == 2,
                onPressed: () {
                  if (index != 2) setState(() => index = 2);
                },
              ),
              NavigationButton(
                icon: Icons.person,
                tooltip: "Characters & Worlds",
                highlight: index == 3,
                onPressed: () {
                  if (index != 3) setState(() => index = 3);
                },
              ),
              NavigationButton(
                icon: Icons.directions_run,
                tooltip: "Actions",
                highlight: index == 4,
                onPressed: () {
                  if (index != 4) setState(() => index = 4);
                },
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: index,
              children: const [
                VideoView(),
                AuthorView(),
                SongView(),
                CharacterView(),
                ActionView(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
