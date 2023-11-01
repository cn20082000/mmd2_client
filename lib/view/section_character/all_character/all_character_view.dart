import 'package:flutter/material.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/world_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_character/widgets/character_form_view.dart';
import 'package:mmd2/view/section_character/widgets/character_item_view.dart';

class AllCharacterView extends StatefulWidget {
  const AllCharacterView({super.key});

  @override
  State<AllCharacterView> createState() => _AllCharacterViewState();
}

class _AllCharacterViewState extends State<AllCharacterView> {
  final characterClient = CharacterClient();

  bool isLoading = false;
  final worldList = <WorldModel>[];
  final characterList = <CharacterModel>[];

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
              "Characters",
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
        onPressed: () {
          CharacterFormView(
            title: "Add new character",
            worldList: worldList,
            onDone: (character) => _createCharacter(character),
          ).showAsDialog(context);
        },
        tooltip: "Add new world",
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
              itemCount: characterList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (_, index) =>
                  CharacterItemView(
                    item: characterList[index],
                    onEdit: () {
                      CharacterFormView(
                        title: "Edit character",
                        item: characterList[index],
                        worldList: worldList,
                        onDone: (character) => _updateCharacter(character),
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
      characterClient.getPagingCharacter(),
      characterClient.getPagingWorld(),
    ]);

    if (response[0]?.data != null) {
      characterList.clear();
      characterList.addAll((response[0]?.data?.data ?? []) as Iterable<CharacterModel>);
    }
    if (response[1]?.data != null) {
      worldList.clear();
      worldList.addAll((response[1]?.data?.data ?? []) as Iterable<WorldModel>);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _createCharacter(CharacterModel character) async {
    final response = await characterClient.createCharacter(character);

    if (response?.data != null) {
      _reloadData();
    }
  }

  Future<void> _updateCharacter(CharacterModel character) async {
    final response = await characterClient.updateCharacter(character);

    if (response?.data != null) {
      _reloadData();
    }
  }
}
