import 'package:flutter/material.dart';
import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/client/video_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_video/widgets/video_item_view.dart';

class AuthorVideoView extends StatefulWidget {
  final AuthorModel author;

  const AuthorVideoView({super.key, required this.author});

  @override
  State<AuthorVideoView> createState() => _AuthorVideoViewState();
}

class _AuthorVideoViewState extends State<AuthorVideoView> {
  final videoClient = VideoClient();
  final authorClient = AuthorClient();

  bool isLoading = false;
  final videoList = <VideoModel>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return SectionScreen(
      appBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              tooltip: "Back",
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(
              widget.author.name ?? "",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            const SizedBox(width: 16),
            IconButton(
              tooltip: "Refresh",
              onPressed: isLoading ? null : () => _reloadData(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () => _syncVideo(),
        tooltip: "Sync videos",
        child: const Icon(Icons.download),
      ),
      body: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(minHeight: 4),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 64,
              ),
              itemCount: videoList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (_, index) => VideoItemView(
                item: videoList[index],
                onEdit: () {
                  // CharacterFormView(
                  //   title: "Edit character",
                  //   item: characterList[index],
                  //   worldList: worldList,
                  //   onDone: (character) => _updateCharacter(character),
                  // ).showAsDialog(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reloadData() async {
    setState(() {
      isLoading = true;
    });
    final response = await Future.wait([
      videoClient.queryVideo(VideoQueryModel(authors: [widget.author])),
    ]);

    if (response[0]?.data != null) {
      videoList.clear();
      videoList.addAll((response[0]?.data?.data ?? []));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _syncVideo() async {
    setState(() {
      isLoading = true;
    });
    final response = await authorClient.syncVideo(widget.author);

    setState(() {
      isLoading = false;
    });

    if (response?.data != null) {
      _reloadData();
    }
  }
}
