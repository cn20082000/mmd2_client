import 'package:flutter/material.dart';
import 'package:mmd2/data/client/video_client.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_video/query_video/widgets/query_form_view.dart';
import 'package:mmd2/view/section_video/query_video/widgets/video_item_view.dart';

class QueryVideoView extends StatefulWidget {
  const QueryVideoView({super.key});

  @override
  State<QueryVideoView> createState() => _QueryVideoViewState();
}

class _QueryVideoViewState extends State<QueryVideoView> {
  final videoClient = VideoClient();

  final loadingCtrl = LoadingListController(20);

  VideoQueryModel query = VideoQueryModel();

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
            Text(
              "Videos",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                QueryFormView(
                  title: "Filter video",
                  query: query,
                  onDone: (newQuery) {
                    query = newQuery;
                    loadingCtrl.reload();
                  },
                ).showAsDialog(context);
              },
              child: const Text("Filter video"),
            ),
            const SizedBox(width: 8),
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
      body: LoadingListView.separated(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => VideoItemView(
          item: item,
          onEdit: () {},
        ),
      ),
    );
  }

  Future<List<VideoModel>> _getData(int pageIndex, int pageSize) async {
    final result = <VideoModel>[];

    final response = await videoClient.queryVideo(pageIndex, pageSize, query);

    if (response?.data != null) {
      result.addAll((response?.data?.data ?? []));
    }

    return result;
  }
}
