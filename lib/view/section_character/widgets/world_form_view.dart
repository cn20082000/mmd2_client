import 'package:flutter/material.dart';
import 'package:mmd2/data/model/world_model.dart';

class WorldFormView extends StatefulWidget {
  final String title;
  final WorldModel? item;
  final void Function(WorldModel)? onDone;

  const WorldFormView({super.key, required this.title, this.onDone, this.item});

  @override
  State<WorldFormView> createState() => _WorldFormViewState();
}

class _WorldFormViewState extends State<WorldFormView> {
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.item?.name ?? "";
    descriptionCtrl.text = widget.item?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              textInputAction: TextInputAction.next,
              maxLength: 255,
              decoration: const InputDecoration(
                hintText: "Name",
              ),
            ),
            TextField(
              controller: descriptionCtrl,
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 5,
              maxLength: 1023,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              onSubmitted: (_) {
                widget.onDone?.call(_buildWorld);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            widget.onDone?.call(_buildWorld);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  WorldModel get _buildWorld => WorldModel(
    id: widget.item?.id,
    name: nameCtrl.text.trim(),
    description: descriptionCtrl.text.trim(),
  );
}
