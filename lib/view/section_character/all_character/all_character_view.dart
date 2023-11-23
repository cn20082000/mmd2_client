import 'package:flutter/material.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
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

  final loadingCtrl = LoadingListController(20);

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
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(
              "Characters",
              style: Theme.of(context).textTheme.headlineSmall,
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
          CharacterFormView(
            title: "Add new character",
            onDone: (character) => _createCharacter(character),
          ).showAsDialog(context);
        },
        tooltip: "Add new world",
        child: const Icon(Icons.add),
      ),
      body: LoadingListView.wrap(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => CharacterItemView(
          item: item,
          onEdit: () {
            CharacterFormView(
              title: "Edit character",
              item: item,
              onDone: (character) => _updateCharacter(character),
            ).showAsDialog(context);
          },
        ),
      ),
    );
  }

  Future<List<CharacterModel>> _getData(int pageIndex, int pageSize) async {
    final result = <CharacterModel>[];

    final response = await characterClient.getPagingCharacter(pageIndex, pageSize);
    if (response?.data != null) {
      result.addAll(response?.data?.data ?? []);
    }

    return result;
  }

  Future<void> _createCharacter(CharacterModel character) async {
    final response = await characterClient.createCharacter(character);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _updateCharacter(CharacterModel character) async {
    final response = await characterClient.updateCharacter(character);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }
}
