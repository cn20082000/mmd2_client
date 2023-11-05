import 'package:flutter/material.dart';
import 'package:mmd2/data/model/action_model.dart';

class ActionFormView extends StatefulWidget {
  final String title;
  final ActionModel? item;
  final void Function(ActionModel)? onDone;

  const ActionFormView({super.key, required this.title, this.onDone, this.item});

  @override
  State<ActionFormView> createState() => _ActionFormViewState();
}

class _ActionFormViewState extends State<ActionFormView> {
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
                labelText: "Name",
              ),
            ),
            TextField(
              controller: descriptionCtrl,
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 5,
              maxLength: 1024,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              onSubmitted: (_) {
                widget.onDone?.call(_buildAction);
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
            widget.onDone?.call(_buildAction);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  ActionModel get _buildAction => ActionModel(
    id: widget.item?.id,
    name: nameCtrl.text.trim(),
    description: descriptionCtrl.text.trim(),
  );
}
