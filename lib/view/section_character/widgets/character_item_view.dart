import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mmd2/common/constants.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/util/extension/string_ext.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';

class CharacterItemView extends StatelessWidget {
  final CharacterModel item;
  final void Function()? onEdit;

  const CharacterItemView({super.key, required this.item, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return BasicItem(
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
              child: CachedNetworkImage(
                imageUrl: item.url.nullOrEmpty(Constants.defaultImage),
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Placeholder(),
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
                        text: " (${item.world?.name ?? ""})",
                        style: Theme.of(context).textTheme.bodyMedium?.bold,
                      ),
                    ],
                  ),
                ),
                Text(
                  item.description ?? "",
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
