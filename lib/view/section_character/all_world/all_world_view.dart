import 'package:flutter/material.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/model/world_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_character/all_character/all_character_view.dart';
import 'package:mmd2/view/section_character/all_world/widgets/world_form_view.dart';
import 'package:mmd2/view/section_character/all_world/widgets/world_item_view.dart';

class AllWorldView extends StatefulWidget {
  const AllWorldView({super.key});

  @override
  State<AllWorldView> createState() => _AllWorldViewState();
}

class _AllWorldViewState extends State<AllWorldView> {
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
            Text(
              "Worlds",
              style: Theme.of(context).textTheme.headlineSmall,
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
          WorldFormView(
            title: "Add new world",
            onDone: (world) => _createWorld(world),
          ).showAsDialog(context);
        },
        tooltip: "Add new world",
        child: const Icon(Icons.add),
      ),
      body: LoadingListView.separated(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => WorldItemView(
          item: item,
          onEdit: () {
            WorldFormView(
              title: "Edit world",
              item: item.data,
              onDone: (world) => _updateWorld(world),
            ).showAsDialog(context);
          },
        ),
      ),
    );
  }

  Future<List<WorldItemModel>> _getData(int pageIndex, int pageSize) async {
    final result = <WorldItemModel>[];

    final response = await characterClient.getPagingWorld(pageIndex, pageSize);
    if (response?.data != null) {
      result.clear();
      result.addAll((response?.data?.data ?? []).map((e) => WorldItemModel(e)));
    }

    return result;
  }

  Future<void> _createWorld(WorldModel world) async {
    final response = await characterClient.createWorld(world);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _updateWorld(WorldModel world) async {
    final response = await characterClient.updateWorld(world);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }
}
