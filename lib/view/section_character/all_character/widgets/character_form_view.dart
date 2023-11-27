import 'package:flutter/material.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/world_model.dart';

class CharacterFormView extends StatefulWidget {
  final String title;
  final CharacterModel? item;
  final void Function(CharacterModel)? onDone;

  const CharacterFormView({super.key, required this.title, this.item, this.onDone});

  @override
  State<CharacterFormView> createState() => _CharacterFormViewState();
}

class _CharacterFormViewState extends State<CharacterFormView> {
  final characterClient = CharacterClient();

  final nameCtrl = TextEditingController();
  final urlCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final worldList = <WorldModel>[];
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllWorldLite();
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
            TextField(
              controller: urlCtrl,
              textInputAction: TextInputAction.next,
              minLines: 1,
              maxLines: 5,
              maxLength: 1024,
              decoration: const InputDecoration(
                labelText: "Url",
              ),
            ),
            TextField(
              controller: descriptionCtrl,
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 5,
              maxLength: 1024,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              onSubmitted: (_) {
                widget.onDone?.call(_buildCharacter);
                Navigator.pop(context);
              },
            ),
            PopupMenuButton(
              itemBuilder: (_) => worldList
                  .map((e) => PopupMenuItem<WorldModel>(
                        value: e,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: e.id == selectedWorld?.id ? const Icon(Icons.check, size: 16) : null,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.name ?? "")),
                          ],
                        ),
                      ))
                  .toList(),
              tooltip: "Select world",
              initialValue: selectedWorld,
              onSelected: (result) {
                setState(() {
                  selectedWorld = result;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedWorld?.name ?? "Select world",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: selectedWorld == null ? Colors.grey : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_drop_down),
                  ],
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

  Future<void> _getAllWorldLite() async {
    final response = await characterClient.getAllWorldLite();
    if (response?.data != null) {
      worldList.clear();
      worldList.addAll(response?.data?.data ?? []);
    }
  }
}
