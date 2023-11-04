import 'package:flutter/material.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/model/producer_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_song/widgets/producer_form_view.dart';
import 'package:mmd2/view/section_song/widgets/producer_item_view.dart';

class AllProducerView extends StatefulWidget {
  const AllProducerView({super.key});

  @override
  State<AllProducerView> createState() => _AllProducerViewState();
}

class _AllProducerViewState extends State<AllProducerView> {
  final songClient = SongClient();

  bool isLoading = false;
  final producerList = <ProducerModel>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return SectionScreen(
      appBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              tooltip: "Back",
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(
              "Producers",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            const SizedBox(width: 16),
            IconButton(
              tooltip: "Refresh",
              onPressed: isLoading ? null : () => _reloadData(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () {
          ProducerFormView(
            title: "Add new producer",
            onDone: (producer) => _createProducer(producer),
          ).showAsDialog(context);
        },
        tooltip: "Add new producer",
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(minHeight: 4),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 64,
              ),
              itemCount: producerList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (_, index) => ProducerItemView(
                item: producerList[index],
                onEdit: () {
                  ProducerFormView(
                    title: "Edit producer",
                    item: producerList[index],
                    onDone: (producer) => _updateProducer(producer),
                  ).showAsDialog(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reloadData() async {
    setState(() {
      isLoading = true;
    });
    final response = await songClient.getPagingProducer();
    if (response?.data != null) {
      producerList.clear();
      producerList.addAll((response?.data?.data ?? []));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _createProducer(ProducerModel producer) async {
    final response = await songClient.createProducer(producer);

    if (response?.data != null) {
      _reloadData();
    }
  }

  Future<void> _updateProducer(ProducerModel producer) async {
    final response = await songClient.updateProducer(producer);

    if (response?.data != null) {
      _reloadData();
    }
  }
}
