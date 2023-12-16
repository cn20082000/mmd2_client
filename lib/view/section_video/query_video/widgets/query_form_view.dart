import 'package:flutter/material.dart';
import 'package:mmd2/data/client/action_client.dart';
import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/enumi/e_orientation.dart';
import 'package:mmd2/data/enumi/e_video_status.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';

class QueryFormView extends StatefulWidget {
  final String title;
  final VideoQueryModel query;
  final void Function(VideoQueryModel)? onDone;

  const QueryFormView({super.key, required this.title, required this.query, this.onDone});

  @override
  State<QueryFormView> createState() => _QueryFormViewState();
}

class _QueryFormViewState extends State<QueryFormView> {
  final actionClient = ActionClient();
  final authorClient = AuthorClient();
  final characterClient = CharacterClient();
  final songClient = SongClient();

  final nameCtrl = TextEditingController();
  final selectedOrientations = <EOrientation>[];
  final selectedStatus = <EVideoStatus>[];
  final selectedAuthors = <AuthorModel>[];
  final selectedSongs = <SongModel>[];
  final selectedCharacters = <CharacterModel>[];
  final selectedActions = <ActionModel>[];

  final actionList = <ActionModel>[];
  final authorList = <AuthorModel>[];
  final characterList = <CharacterModel>[];
  final songList = <SongModel>[];

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.query.name ?? "";
    selectedOrientations.addAll(widget.query.orientations);
    selectedStatus.addAll(widget.query.status);
    selectedAuthors.addAll(widget.query.authors);
    selectedSongs.addAll(widget.query.songs);
    selectedCharacters.addAll(widget.query.characters);
    selectedActions.addAll(widget.query.actions);
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
              autofocus: true,
              textInputAction: TextInputAction.next,
              maxLength: 255,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            _buildAuthorFilter(context),
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
            widget.onDone?.call(_buildQuery);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  Widget _buildAuthorFilter(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => authorList
          .map((e) => PopupMenuItem<AuthorModel>(
                value: e,
                child: Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: selectedAuthors.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Text(e.name ?? ""),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select authors",
      initialValue: selectedAuthors.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (selectedAuthors.map((e) => e.id).contains(result.id)) {
            selectedAuthors.removeWhere((element) => element.id == result.id);
          } else {
            selectedAuthors.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedAuthors.isEmpty ? "Select authors" : selectedAuthors.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedAuthors.isEmpty ? Colors.grey : null),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
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
                      child: selectedOrientations.contains(e) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.title)),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select orientations",
      initialValue: selectedOrientations.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (selectedOrientations.contains(result)) {
            selectedOrientations.remove(result);
          } else {
            selectedOrientations.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedOrientations.isEmpty ? "Select orientations" : selectedOrientations.map((e) => e.title).join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedOrientations.isEmpty ? Colors.grey : null),
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
                      child: selectedStatus.contains(e) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.title)),
                  ],
                ),
              ))
          .toList(),
      tooltip: "Select status",
      initialValue: selectedStatus.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (selectedStatus.contains(result)) {
            selectedStatus.remove(result);
          } else {
            selectedStatus.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedStatus.isEmpty ? "Select status" : selectedStatus.map((e) => e.title).join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedStatus.isEmpty ? Colors.grey : null),
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

  VideoQueryModel get _buildQuery => VideoQueryModel(
        name: nameCtrl.text,
        orientations: selectedOrientations,
        status: selectedStatus,
        authors: selectedAuthors,
        songs: selectedSongs,
        characters: selectedCharacters,
        actions: selectedActions,
      );

  Future<void> _getAllLite() async {
    final response = await Future.wait([
      actionClient.getAllActionLite(),
      authorClient.getAllAuthorLite(),
      characterClient.getAllCharacterLite(),
      songClient.getAllSongLite(),
    ]);

    if (response[0]?.data != null) {
      actionList.clear();
      actionList.addAll((response[0]?.data?.data ?? []) as Iterable<ActionModel>);
    }

    if (response[1]?.data != null) {
      authorList.clear();
      authorList.addAll((response[1]?.data?.data ?? []) as Iterable<AuthorModel>);
    }

    if (response[2]?.data != null) {
      characterList.clear();
      characterList.addAll((response[2]?.data?.data ?? []) as Iterable<CharacterModel>);
    }

    if (response[3]?.data != null) {
      songList.clear();
      songList.addAll((response[3]?.data?.data ?? []) as Iterable<SongModel>);
    }
  }
}
