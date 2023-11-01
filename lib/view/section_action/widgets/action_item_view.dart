import 'package:flutter/material.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';
import 'package:mmd2/view/custom/list/basic_item.dart';

class ActionItemView extends StatelessWidget {
  final ActionModel item;
  final void Function()? onEdit;

  const ActionItemView({super.key, required this.item, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return BasicItem(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onPressed: () {},
      child: Row(
        children: [
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
