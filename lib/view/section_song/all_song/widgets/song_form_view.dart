import 'package:flutter/material.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/model/producer_model.dart';
import 'package:mmd2/data/model/song_model.dart';

class SongFormView extends StatefulWidget {
  final String title;
  final SongModel? item;
  final void Function(SongModel)? onDone;

  const SongFormView({super.key, required this.title, this.item, this.onDone});

  @override
  State<SongFormView> createState() => _SongFormViewState();
}

class _SongFormViewState extends State<SongFormView> {
  final songClient = SongClient();

  final nameCtrl = TextEditingController();
  final urlCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final selectedProducer = <ProducerModel>[];

  final producerList = <ProducerModel>[];

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.item?.name ?? "";
    urlCtrl.text = widget.item?.url ?? "";
    descriptionCtrl.text = widget.item?.description ?? "";
    selectedProducer.addAll(widget.item?.producers ?? []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllProducerLite();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              controller: urlCtrl,
              textInputAction: TextInputAction.next,
              minLines: 1,
              maxLines: 5,
              maxLength: 1024,
              decoration: const InputDecoration(
                labelText: "Url",
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
                widget.onDone?.call(_buildSong);
                Navigator.pop(context);
              },
            ),
            PopupMenuButton(
              itemBuilder: (_) => producerList
                  .map((e) => PopupMenuItem<ProducerModel>(
                        value: e,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: selectedProducer.map((p) => p.id).contains(e.id) ? const Icon(Icons.check, size: 16) : null,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.name ?? "")),
                          ],
                        ),
                      ))
                  .toList(),
              tooltip: "Select producers",
              initialValue: selectedProducer.lastOrNull,
              onSelected: (result) {
                setState(() {
                  if (selectedProducer.map((e) => e.id).contains(result.id)) {
                    selectedProducer.removeWhere((element) => element.id == result.id);
                  } else {
                    selectedProducer.add(result);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedProducer.isEmpty ? "Select producers" : selectedProducer.map((e) => e.name ?? "").join(", "),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: selectedProducer.isEmpty ? Colors.grey : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
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
            widget.onDone?.call(_buildSong);
            Navigator.pop(context);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }

  SongModel get _buildSong => SongModel(
        id: widget.item?.id,
        name: nameCtrl.text.trim(),
        url: urlCtrl.text.trim(),
        description: descriptionCtrl.text.trim(),
        producers: selectedProducer,
      );

  Future<void> _getAllProducerLite() async {
    final response = await songClient.getAllProducerLite();
    if (response?.data != null) {
      producerList.clear();
      producerList.addAll(response?.data?.data ?? []);
    }
  }
}
