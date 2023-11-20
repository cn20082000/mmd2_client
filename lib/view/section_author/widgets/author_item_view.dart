import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/common/constants.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/util/extension/string_ext.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';
import 'package:url_launcher/url_launcher.dart';

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
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IconButton(
                onPressed: () => launchUrl(Uri.parse(item.profileUrl ?? "")),
                icon: const Icon(Icons.call_made),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
