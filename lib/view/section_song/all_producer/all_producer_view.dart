import 'package:flutter/material.dart';
import 'package:mmd2/data/client/song_client.dart';
import 'package:mmd2/data/model/producer_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_song/all_producer/widgets/producer_form_view.dart';
import 'package:mmd2/view/section_song/all_producer/widgets/producer_item_view.dart';

class AllProducerView extends StatefulWidget {
  const AllProducerView({super.key});

  @override
  State<AllProducerView> createState() => _AllProducerViewState();
}

class _AllProducerViewState extends State<AllProducerView> {
  final songClient = SongClient();

  final loadingCtrl = LoadingListController(20);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadingCtrl.getData = _getData;
    loadingCtrl.reload();
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
            LoadingView(
              controller: loadingCtrl,
              builder: (loading) => IconButton(
                tooltip: "Refresh",
                onPressed: loading ? null : loadingCtrl.reload,
                icon: const Icon(Icons.refresh),
              ),
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
      body: LoadingListView.separated(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => ProducerItemView(
          item: item,
          onEdit: () {
            ProducerFormView(
              title: "Edit producer",
              item: item,
              onDone: (producer) => _updateProducer(producer),
            ).showAsDialog(context);
          },
        ),
      ),
    );
  }

  Future<List<ProducerModel>> _getData(int pageIndex, int pageSize) async {
    final result = <ProducerModel>[];

    final response = await songClient.getPagingProducer(pageIndex, pageSize);
    if (response?.data != null) {
      result.addAll(response?.data?.data ?? []);
    }

    return result;
  }

  Future<void> _createProducer(ProducerModel producer) async {
    final response = await songClient.createProducer(producer);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _updateProducer(ProducerModel producer) async {
    final response = await songClient.updateProducer(producer);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }
}
