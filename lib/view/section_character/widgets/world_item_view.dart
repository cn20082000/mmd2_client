import 'package:flutter/material.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/world_model.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';
import 'package:mmd2/view/section_character/widgets/character_form_view.dart';

class WorldItemView extends StatefulWidget {
  final WorldModel item;
  final List<WorldModel> worldList;
  final void Function()? onEdit;
  final Future<List<CharacterModel>> Function()? onGetCharacters;

  const WorldItemView({super.key, required this.item, this.onEdit, this.onGetCharacters, required this.worldList});

  @override
  State<WorldItemView> createState() => _WorldItemViewState();
}

class _WorldItemViewState extends State<WorldItemView> {
  final characterClient = CharacterClient();

  final characterList = <CharacterModel>[];
  bool isExpand = false;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.id != oldWidget.item.id) {
      setState(() {
        characterList.clear();
        isExpand = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BasicItem(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          onPressed: () {},
          child: _buildWorld(context),
        ),
        if (isExpand)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: characterList.map((e) => _buildCharacterItem(e, context)).toList() + [
                FloatingActionButton(
                  onPressed: () async {
                    CharacterFormView(
                      title: "Add character",
                      item: CharacterModel(
                        world: widget.item,
                      ),
                      worldList: widget.worldList,
                      onDone: (c) => _createCharacter(c),
                    ).showAsDialog(context);
                  },
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildWorld(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.item.name ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                widget.item.description ?? "",
                style: Theme.of(context).textTheme.bodyMedium?.grey,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: widget.onEdit,
          icon: const Icon(Icons.edit),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () async {
            isExpand = !isExpand;
            setState(() {});
            if (isExpand) {
              characterList.clear();
              characterList.addAll(await widget.onGetCharacters?.call() ?? []);
            }
            setState(() {});
          },
          icon: Icon(isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Widget _buildCharacterItem(CharacterModel e, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
      child: BasicItem(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        onPressed: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 64,
                width: 64,
                child: Image.network(
                  e.url ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Placeholder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  e.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  onPressed: () {
                    CharacterFormView(
                      title: "Edit character",
                      item: e,
                      worldList: widget.worldList,
                      onDone: (c) => _updateCharacter(c),
                    ).showAsDialog(context);
                  },
                  icon: const Icon(Icons.edit, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createCharacter(CharacterModel character) async {
    final response = await characterClient.createCharacter(character);

    if (response?.data != null) {
      characterList.clear();
      characterList.addAll(await widget.onGetCharacters?.call() ?? []);
    }
  }

  Future<void> _updateCharacter(CharacterModel character) async {
    final response = await characterClient.updateCharacter(character);

    if (response?.data != null) {
      characterList.clear();
      characterList.addAll(await widget.onGetCharacters?.call() ?? []);
    }
  }
}
