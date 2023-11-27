import 'package:flutter/material.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';
import 'package:mmd2/util/utils.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';

class SongItemView extends StatelessWidget {
  final SongModel item;
  final void Function()? onEdit;

  const SongItemView({super.key, required this.item, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return BasicItem(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onPressed: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: InkWell(
              onTap: () => Utils.launchUrl(item.url ?? ""),
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox(
                height: 64,
                width: 64,
                child: Center(
                  child: Icon(Icons.play_circle),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  item.description ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.grey,
                ),
                Text(
                  "Producer: ${(item.producers ?? []).map((e) => e.name ?? "").join(", ")}",
                  style: Theme.of(context).textTheme.bodyMedium?.grey,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
