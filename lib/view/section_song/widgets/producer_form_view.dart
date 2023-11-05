import 'package:flutter/material.dart';
import 'package:mmd2/data/model/producer_model.dart';

class ProducerFormView extends StatefulWidget {
  final String title;
  final ProducerModel? item;
  final void Function(ProducerModel)? onDone;

  const ProducerFormView({super.key, required this.title, this.onDone, this.item});

  @override
  State<ProducerFormView> createState() => _ProducerFormViewState();
}

class _ProducerFormViewState extends State<ProducerFormView> {
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
                widget.onDone?.call(_buildProducer);
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
            widget.onDone?.call(_buildProducer);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  ProducerModel get _buildProducer => ProducerModel(
    id: widget.item?.id,
    name: nameCtrl.text.trim(),
    description: descriptionCtrl.text.trim(),
  );
}
