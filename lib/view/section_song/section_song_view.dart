import 'package:flutter/material.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_song/all_producer/all_producer_view.dart';
import 'package:mmd2/view/section_song/widgets/song_form_view.dart';
import 'package:mmd2/view/section_song/widgets/song_item_view.dart';

class SectionSongView extends StatefulWidget {
  const SectionSongView({super.key});

  @override
  State<SectionSongView> createState() => _SectionSongViewState();
}

class _SectionSongViewState extends State<SectionSongView> {
  final songClient = SongClient();

  final loadingCtrl = LoadingListController(20);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadingCtrl.getData = _getData;
    loadingCtrl.reload();
  }

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(
      builder: (ctx) => _buildScreen(ctx),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return SectionScreen(
      appBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              "Songs",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AllProducerView()));
              },
              child: const Text("All producers >"),
            ),
            const Spacer(),
            const SizedBox(width: 16),
            LoadingView(
              controller: loadingCtrl,
              builder: (loading) => IconButton(
                tooltip: "Refresh",
                onPressed: loading ? null : loadingCtrl.reload,
                icon: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () {
          SongFormView(
            title: "Add new song",
            onDone: (song) => _createSong(song),
          ).showAsDialog(context);
        },
        tooltip: "Add new song",
        child: const Icon(Icons.add),
      ),
      body: LoadingListView.separated(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => SongItemView(
          item: item,
          onEdit: () {
            SongFormView(
              title: "Edit song",
              item: item,
              onDone: (song) => _updateSong(song),
            ).showAsDialog(context);
          },
        ),
      ),
    );
  }

  Future<List<SongModel>> _getData(int pageIndex, int pageSize) async {
    final result = <SongModel>[];

    final response = await songClient.getPagingSong(pageIndex, pageSize);
    if (response?.data != null) {
      result.addAll(response?.data?.data ?? []);
    }

    return result;
  }

  Future<void> _createSong(SongModel song) async {
    final response = await songClient.createSong(song);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _updateSong(SongModel song) async {
    final response = await songClient.updateSong(song);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }
}
