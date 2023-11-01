import 'package:flutter/material.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/world_model.dart';

class CharacterFormView extends StatefulWidget {
  final String title;
  final CharacterModel? item;
  final List<WorldModel> worldList;
  final void Function(CharacterModel)? onDone;

  const CharacterFormView({super.key, required this.title, this.item, required this.worldList, this.onDone});

  @override
  State<CharacterFormView> createState() => _CharacterFormViewState();
}

class _CharacterFormViewState extends State<CharacterFormView> {
  final nameCtrl = TextEditingController();
  final urlCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  WorldModel? selectedWorld;

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.item?.name ?? "";
    urlCtrl.text = widget.item?.url ?? "";
    descriptionCtrl.text = widget.item?.description ?? "";
    selectedWorld = widget.item?.world;
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
                hintText: "Name",
              ),
            ),
            TextField(
              controller: urlCtrl,
              autofocus: true,
              textInputAction: TextInputAction.next,
              maxLength: 255,
              decoration: const InputDecoration(
                hintText: "Url",
              ),
            ),
            TextField(
              controller: descriptionCtrl,
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 5,
              maxLength: 1023,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              onSubmitted: (_) {
                widget.onDone?.call(_buildCharacter);
                Navigator.pop(context);
              },
            ),
            PopupMenuButton(
              itemBuilder: (_) => widget.worldList.map((e) => PopupMenuItem<WorldModel>(
                value: e,
                child: Text(e.name ?? ""),
              )).toList(),
              initialValue: selectedWorld,
              onSelected: (result) {
                setState(() {
                  selectedWorld = result;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  selectedWorld?.name ?? "Select world",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
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
            widget.onDone?.call(_buildCharacter);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  CharacterModel get _buildCharacter => CharacterModel(
    id: widget.item?.id,
    name: nameCtrl.text.trim(),
    url: urlCtrl.text.trim(),
    description: descriptionCtrl.text.trim(),
    world: selectedWorld,
  );
}
