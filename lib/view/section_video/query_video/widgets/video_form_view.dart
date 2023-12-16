import 'package:flutter/material.dart';
import 'package:mmd2/data/client/action_client.dart';
import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/enumi/e_orientation.dart';
import 'package:mmd2/data/enumi/e_video_status.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';

class VideoFormView extends StatefulWidget {
  final String title;
  final VideoModel? item;
  final void Function(VideoModel)? onDone;

  const VideoFormView({super.key, required this.title, this.item, this.onDone});

  @override
  State<VideoFormView> createState() => _VideoFormViewState();
}

class _VideoFormViewState extends State<VideoFormView> {
  final actionClient = ActionClient();
  final authorClient = AuthorClient();
  final characterClient = CharacterClient();
  final songClient = SongClient();

  final nameCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  final localRelativeUrlCtrl = TextEditingController();
  EOrientation? selectedOrientation;
  EVideoStatus? selectedStatus;
  final selectedSongs = <SongModel>[];
  final selectedCharacters = <CharacterModel>[];
  final selectedActions = <ActionModel>[];

  final actionList = <ActionModel>[];
  final characterList = <CharacterModel>[];
  final songList = <SongModel>[];

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.item?.name ?? "";
    authorCtrl.text = widget.item?.author?.name ?? "";
    localRelativeUrlCtrl.text = widget.item?.localRelativeUrl ?? "";
    selectedOrientation = widget.item?.orientation;
    selectedStatus = widget.item?.status;
    selectedSongs.addAll(widget.item?.songs ?? []);
    selectedCharacters.addAll(widget.item?.characters ?? []);
    selectedActions.addAll(widget.item?.actions ?? []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllLite();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: authorCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Author",
              ),
            ),
            TextField(
              controller: localRelativeUrlCtrl,
              autofocus: true,
              textInputAction: TextInputAction.next,
              maxLength: 255,
              decoration: const InputDecoration(
                labelText: "Local relative url",
              ),
            ),
            _buildOrientationFilter(context),
            _buildVideoStatusFilter(context),
            _buildSongFilter(context),
            _buildCharacterFilter(context),
            _buildActionFilter(context),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            widget.onDone?.call(_buildVideo);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  Widget _buildOrientationFilter(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => EOrientation.values
          .map((e) => PopupMenuItem<EOrientation>(
                value: e,
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: selectedOrientation == e ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.title)),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select orientations",
      initialValue: selectedOrientation,
      onSelected: (result) {
        setState(() {
          if (selectedOrientation == result) {
            selectedOrientation = null;
          } else {
            selectedOrientation = result;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedOrientation?.title ?? "Select orientations",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedOrientation == null ? Colors.grey : null),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoStatusFilter(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => EVideoStatus.values
          .map((e) => PopupMenuItem<EVideoStatus>(
                value: e,
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: selectedStatus == e ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.title)),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select status",
      initialValue: selectedStatus,
      onSelected: (result) {
        setState(() {
          if (selectedStatus == result) {
            selectedStatus = null;
          } else {
            selectedStatus = result;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedStatus?.title ?? "Select status",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedStatus == null ? Colors.grey : null),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildSongFilter(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => songList
          .map((e) => PopupMenuItem<SongModel>(
                value: e,
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: selectedSongs.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(text: e.name ?? ""),
                          TextSpan(
                            text: (e.producers?.length ?? 0) > 0 ? " (${e.producers?.map((e) => e.name ?? "").join(", ")})" : "",
                            style: Theme.of(context).textTheme.bodyMedium?.grey,
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select songs",
      initialValue: selectedSongs.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (selectedSongs.map((e) => e.id).contains(result.id)) {
            selectedSongs.removeWhere((element) => element.id == result.id);
          } else {
            selectedSongs.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedSongs.isEmpty ? "Select songs" : selectedSongs.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedSongs.isEmpty ? Colors.grey : null),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterFilter(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => characterList
          .map((e) => PopupMenuItem<CharacterModel>(
                value: e,
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: selectedCharacters.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(text: e.name ?? ""),
                          TextSpan(
                            text: e.world != null ? " (${e.world?.name ?? ""})" : "",
                            style: Theme.of(context).textTheme.bodyMedium?.grey,
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select characters",
      initialValue: selectedCharacters.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (selectedCharacters.map((e) => e.id).contains(result.id)) {
            selectedCharacters.removeWhere((element) => element.id == result.id);
          } else {
            selectedCharacters.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedCharacters.isEmpty ? "Select characters" : selectedCharacters.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedCharacters.isEmpty ? Colors.grey : null),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildActionFilter(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => actionList
          .map((e) => PopupMenuItem<ActionModel>(
                value: e,
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: selectedActions.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.name ?? "")),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select actions",
      initialValue: selectedActions.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (selectedActions.map((e) => e.id).contains(result.id)) {
            selectedActions.removeWhere((element) => element.id == result.id);
          } else {
            selectedActions.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedActions.isEmpty ? "Select actions" : selectedActions.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedActions.isEmpty ? Colors.grey : null),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  VideoModel get _buildVideo => VideoModel(
        id: widget.item?.id,
        localRelativeUrl: localRelativeUrlCtrl.text,
        orientation: selectedOrientation,
        status: selectedStatus,
        songs: selectedSongs,
        characters: selectedCharacters,
        actions: selectedActions,
      );

  Future<void> _getAllLite() async {
    final response = await Future.wait([
      actionClient.getAllActionLite(),
      characterClient.getAllCharacterLite(),
      songClient.getAllSongLite(),
    ]);

    if (response[0]?.data != null) {
      actionList.clear();
      actionList.addAll((response[0]?.data?.data ?? []) as Iterable<ActionModel>);
    }

    if (response[1]?.data != null) {
      characterList.clear();
      characterList.addAll((response[1]?.data?.data ?? []) as Iterable<CharacterModel>);
    }

    if (response[2]?.data != null) {
      songList.clear();
      songList.addAll((response[2]?.data?.data ?? []) as Iterable<SongModel>);
    }
  }
}
