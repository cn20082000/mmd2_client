import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mmd2/common/constants.dart';
import 'package:mmd2/data/client/character_client.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/world_model.dart';
import 'package:mmd2/util/extension/string_ext.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/section_character/all_character/widgets/character_form_view.dart';

class WorldItemView extends StatefulWidget {
  final WorldItemModel item;
  final void Function()? onEdit;

  const WorldItemView({super.key, required this.item, this.onEdit});

  @override
  State<WorldItemView> createState() => _WorldItemViewState();
}

class _WorldItemViewState extends State<WorldItemView> {
  final characterClient = CharacterClient();

  @override
  void didUpdateWidget(covariant WorldItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.data.id != oldWidget.item.data.id) {
      widget.item.loadingCtrl.clearListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.item.loadingCtrl.clearListener();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BasicItem(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          onPressed: () {},
          child: _buildWorld(context),
        ),
        if (widget.item.isExpand)
          Container(
            height: 80,
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: LoadingListView.separated(
                    controller: widget.item.loadingCtrl,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, __, item) => _buildCharacter(item: item),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () async {
                    CharacterFormView(
                      title: "Add new character",
                      item: CharacterModel(
                        world: widget.item.data,
                      ),
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
                widget.item.data.name ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                widget.item.data.description ?? "",
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
            setState(() {
              widget.item.isExpand = !widget.item.isExpand;
            });
            if (widget.item.isExpand) {
              widget.item.loadingCtrl.reload();
            }
          },
          icon: Icon(widget.item.isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Widget _buildCharacter({required CharacterModel item}) {
    return BasicItem(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onPressed: () {},
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: item.url.nullOrEmpty(Constants.defaultImage),
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Placeholder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 120,
              maxWidth: 200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.description ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.grey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: () {
              CharacterFormView(
                title: "Edit character",
                item: item,
                onDone: (c) => _updateCharacter(c),
              ).showAsDialog(context);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Future<void> _createCharacter(CharacterModel character) async {
    final response = await characterClient.createCharacter(character);

    if (response?.data != null) {
      widget.item.loadingCtrl.reload();
    }
  }

  Future<void> _updateCharacter(CharacterModel character) async {
    final response = await characterClient.updateCharacter(character);

    if (response?.data != null) {
      widget.item.loadingCtrl.reload();
    }
  }
}

class WorldItemModel {
  final WorldModel data;
  bool isExpand = false;
  final LoadingListController loadingCtrl = LoadingListController(20);

  WorldItemModel(this.data) {
    loadingCtrl.getData = _getData;
  }

  Future<List<CharacterModel>> _getData(int pageIndex, int pageSize) async {
    final result = <CharacterModel>[];

    final client = CharacterClient();
    final response = await client.getPagingCharacterByWorld(data, pageIndex, pageSize);
    if (response?.data != null) {
      result.clear();
      result.addAll(response?.data?.data ?? []);
    }

    return result;
  }
}
