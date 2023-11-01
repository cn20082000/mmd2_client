import 'package:flutter/material.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/world_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_character/all_character/all_character_view.dart';
import 'package:mmd2/view/section_character/widgets/world_form_view.dart';
import 'package:mmd2/view/section_character/widgets/world_item_view.dart';

class SectionCharacterView extends StatefulWidget {
  const SectionCharacterView({super.key});

  @override
  State<SectionCharacterView> createState() => _SectionCharacterViewState();
}

class _SectionCharacterViewState extends State<SectionCharacterView> {
  final characterClient = CharacterClient();

  bool isLoading = false;
  final worldList = <WorldModel>[];

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
              "Worlds",
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AllCharacterView()));
              },
              child: const Text("All characters >"),
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
          WorldFormView(
            title: "Add new world",
            onDone: (world) => _createWorld(world),
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
              itemCount: worldList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (_, index) =>
                  WorldItemView(
                    item: worldList[index],
                    worldList: worldList,
                    onEdit: () {
                      WorldFormView(
                        title: "Edit world",
                        item: worldList[index],
                        onDone: (world) => _updateWorld(world),
                      ).showAsDialog(context);
                    },
                    onGetCharacters: () => _getCharacterDataByWorld(worldList[index]),
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
    final response = await characterClient.getPagingWorld();
    if (response?.data != null) {
      worldList.clear();
      worldList.addAll(response?.data?.data ?? []);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<List<CharacterModel>> _getCharacterDataByWorld(WorldModel world) async {
    setState(() {
      isLoading = true;
    });
    final response = await characterClient.getPagingCharacterByWorld(world);
    setState(() {
      isLoading = false;
    });
    if (response?.data != null) {
      return response?.data?.data ?? [];
    }
    return [];
  }

  Future<void> _createWorld(WorldModel world) async {
    final response = await characterClient.createWorld(world);

    if (response?.data != null) {
      _reloadData();
    }
  }

  Future<void> _updateWorld(WorldModel world) async {
    final response = await characterClient.updateWorld(world);

    if (response?.data != null) {
      _reloadData();
    }
  }
}
