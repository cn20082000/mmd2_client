import 'package:flutter/material.dart';
import 'package:mmd2/data/client/action_client.dart';
import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';
import 'package:mmd2/util/enumi/e_orientation.dart';
import 'package:mmd2/util/enumi/e_video_status.dart';

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

  late VideoQueryModel query;

  final actionList = <ActionModel>[];
  final authorList = <AuthorModel>[];
  final characterList = <CharacterModel>[];
  final songList = <SongModel>[];

  @override
  void initState() {
    super.initState();
    query = VideoQueryModel.fromJson(widget.query.toJson());
    nameCtrl.text = query.name ?? "";
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
              onChanged: (name) {
                query.name = name;
              },
            ),
            _buildAuthorFilter(context),
            _buildVideoStatusFilter(context),
            _buildOrientationFilter(context),
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
            widget.onDone?.call(query);
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
                      child: query.authors.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Text(e.name ?? ""),
                  ],
                ),
              ))
          .toList(),
      initialValue: query.authors.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (query.authors.map((e) => e.id).contains(result.id)) {
            query.authors.removeWhere((element) => element.id == result.id);
          } else {
            query.authors.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query.authors.isEmpty ? "Select authors" : query.authors.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: query.authors.isEmpty ? Colors.grey : null,
                ),
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
                      child: query.status.contains(e) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.title)),
                  ],
                ),
              ))
          .toList(),
      initialValue: query.status.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (query.status.contains(result)) {
            query.status.remove(result);
          } else {
            query.status.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query.status.isEmpty ? "Select status" : query.status.map((e) => e.title).join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: query.status.isEmpty ? Colors.grey : null,
                ),
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
                      child: query.orientations.contains(e) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.title)),
                  ],
                ),
              ))
          .toList(),
      initialValue: query.orientations.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (query.orientations.contains(result)) {
            query.orientations.remove(result);
          } else {
            query.orientations.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query.orientations.isEmpty ? "Select orientations" : query.orientations.map((e) => e.title).join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: query.orientations.isEmpty ? Colors.grey : null,
                ),
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
                      child: query.songs.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.name ?? "")),
                  ],
                ),
              ))
          .toList(),
      initialValue: query.songs.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (query.songs.map((e) => e.id).contains(result.id)) {
            query.songs.removeWhere((element) => element.id == result.id);
          } else {
            query.songs.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query.songs.isEmpty ? "Select songs" : query.songs.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: query.songs.isEmpty ? Colors.grey : null,
                ),
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
                      child: query.characters.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.name ?? "")),
                  ],
                ),
              ))
          .toList(),
      initialValue: query.characters.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (query.characters.map((e) => e.id).contains(result.id)) {
            query.characters.removeWhere((element) => element.id == result.id);
          } else {
            query.characters.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query.characters.isEmpty ? "Select characters" : query.characters.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: query.characters.isEmpty ? Colors.grey : null,
                ),
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
                      child: query.actions.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.name ?? "")),
                  ],
                ),
              ))
          .toList(),
      initialValue: query.actions.lastOrNull,
      onSelected: (result) {
        setState(() {
          if (query.actions.map((e) => e.id).contains(result.id)) {
            query.actions.removeWhere((element) => element.id == result.id);
          } else {
            query.actions.add(result);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query.actions.isEmpty ? "Select actions" : query.actions.map((e) => e.name ?? "").join(", "),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: query.actions.isEmpty ? Colors.grey : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

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
