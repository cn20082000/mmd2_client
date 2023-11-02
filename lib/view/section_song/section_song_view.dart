import 'package:flutter/material.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/model/producer_model.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_song/widgets/song_form_view.dart';
import 'package:mmd2/view/section_song/widgets/song_item_view.dart';

class SectionSongView extends StatefulWidget {
  const SectionSongView({super.key});

  @override
  State<SectionSongView> createState() => _SectionSongViewState();
}

class _SectionSongViewState extends State<SectionSongView> {
  final songClient = SongClient();

  bool isLoading = false;
  final songList = <SongModel>[];
  final producerList = <ProducerModel>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadData();
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
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {},
              child: const Text("All producers >"),
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
        onPressed: () {
          SongFormView(
            title: "Add new song",
            producerList: producerList,
            onDone: (song) => _createSong(song),
          ).showAsDialog(context);
        },
        tooltip: "Add new song",
        child: const Icon(Icons.add),
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
              itemCount: songList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (_, index) =>
                  SongItemView(
                    item: songList[index],
                    onEdit: () {
                      SongFormView(
                        title: "Edit song",
                        item: songList[index],
                        producerList: producerList,
                        onDone: (song) => _updateSong(song),
                      ).showAsDialog(context);
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
      songClient.getPagingSong(),
      songClient.getPagingProducer(),
    ]);

    if (response[0]?.data != null) {
      songList.clear();
      songList.addAll((response[0]?.data?.data ?? []) as Iterable<SongModel>);
    }
    if (response[1]?.data != null) {
      producerList.clear();
      producerList.addAll((response[1]?.data?.data ?? []) as Iterable<ProducerModel>);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _createSong(SongModel song) async {
    final response = await songClient.createSong(song);

    if (response?.data != null) {
      _reloadData();
    }
  }

  Future<void> _updateSong(SongModel song) async {
    final response = await songClient.updateSong(song);

    if (response?.data != null) {
      _reloadData();
    }
  }
}
