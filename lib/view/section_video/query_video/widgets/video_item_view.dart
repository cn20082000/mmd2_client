import 'package:flutter/material.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/util/utils.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';

class VideoItemView extends StatelessWidget {
  final VideoModel item;
  final void Function()? onEdit;

  const VideoItemView({super.key, required this.item, this.onEdit});

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
              onTap: () => Utils.launchUrl(item.cloudUrl ?? ""),
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
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: item.name ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: " [${item.status?.title ?? ""}]",
                        style: Theme.of(context).textTheme.bodyMedium?.bold.copyWith(
                          color: item.status?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Author: ${item.author?.name ?? ""}",
                        style: Theme.of(context).textTheme.bodyMedium?.grey,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        "Actions: ${item.actions?.map((e) => e.name ?? "").join(", ") ?? ""}",
                        style: Theme.of(context).textTheme.bodyMedium?.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Songs: ${item.songs?.map((e) => e.name ?? "").join(", ") ?? ""}",
                  style: Theme.of(context).textTheme.bodyMedium?.grey,
                ),
                Text(
                  "Characters: ${item.characters?.map((e) => e.name ?? "").join(", ") ?? ""}",
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
