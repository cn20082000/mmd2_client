import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/common/constants.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/util/extension/date_ext.dart';
import 'package:mmd2/util/extension/string_ext.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';

class AuthorItemView extends StatelessWidget {
  final AuthorModel item;
  final void Function()? onEdit;
  final void Function()? onPressed;

  const AuthorItemView({super.key, required this.item, this.onEdit, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BasicItem(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 240),
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: item.avatarUrl.nullOrEmpty(Constants.defaultImage),
                    fit: BoxFit.cover,
                    httpHeaders: App.additionHeader,
                    errorWidget: (_, __, ___) => const Placeholder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filledTonal(
                      onPressed: () => App.uc.browser.launchUrl.invoke(item.profileUrl),
                      icon: const Icon(Icons.call_made),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.name ?? "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            "Updated: ${item.lastUpdated?.format(Constants.displayDateTimeFormat) ?? ""}",
            style: Theme.of(context).textTheme.bodyMedium?.grey,
          ),
          Text(
            "Videos: ${item.videosCount ?? 0}",
            style: Theme.of(context).textTheme.bodyMedium?.grey,
          ),
        ],
      ),
    );
  }
}
