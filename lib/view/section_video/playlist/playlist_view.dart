import 'package:flutter/material.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_video/query_video/widgets/video_item_view.dart';

class PlaylistView extends StatefulWidget {
  final List<VideoModel> playlist;
  const PlaylistView({super.key, required this.playlist});

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {

  final loadingCtrl = LoadingListController(999999);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadingCtrl.getData = _getData;
    loadingCtrl.reload();
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
              onPressed: () => Navigator.of(context).pop(loadingCtrl.data),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(
              "Playlist",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                Navigator.pop(context, []);
              },
              icon: const Icon(Icons.playlist_remove),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
      body: LoadingListView(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => VideoItemView(
          item: item,
          onRemove: () {
            loadingCtrl.data.remove(item);
            loadingCtrl.invokeListeners();
          },
        ),
      ),
    );
  }

  Future<List<VideoModel>> _getData(int pageIndex, int pageSize) async {
    return widget.playlist;
  }
}
