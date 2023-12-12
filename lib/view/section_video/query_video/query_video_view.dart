import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mmd2/data/client/video_client.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';
import 'package:mmd2/util/enumi/e_video_status.dart';
import 'package:mmd2/util/extension/text_style_extension.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_video/query_video/widgets/query_form_view.dart';
import 'package:mmd2/view/section_video/query_video/widgets/video_form_view.dart';
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
  final playlist = <VideoModel>[];

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
            IconButton(
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
              icon: const Icon(Icons.filter_alt),
              tooltip: "Filter video",
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
      floatingButton: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(4, 4),
            blurRadius: 4,
          ),
        ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _addAllToPlaylist(),
              icon: const Icon(
                Icons.done_all,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {},
              child: Text(
                "${playlist.length} videos",
                style: Theme.of(context).textTheme.bodyMedium?.bold,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_arrow,
              ),
            ),
          ],
        ),
      ),
      body: LoadingListView.separated(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) {
          if (item is VideoModel) {
            return VideoItemView(
              item: item,
              onEdit: () {
                VideoFormView(
                  title: "Edit video",
                  item: item,
                  onDone: (video) => _updateVideo(video),
                ).showAsDialog(context);
              },
              onCheck: item.status == EVideoStatus.active
                  ? () {
                      setState(() {
                        playlist.add(item);
                      });
                    }
                  : null,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Future<List<VideoModel>> _getData(int pageIndex, int pageSize) async {
    final result = <VideoModel>[];

    final response = await videoClient.queryVideo(pageIndex, pageSize, query);

    if (response?.data != null) {
      result.addAll(response?.data?.data ?? []);
    }

    return result;
  }

  Future<void> _updateVideo(VideoModel video) async {
    final response = await videoClient.updateVideo(video);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _addAllToPlaylist() async {
    if (query.status.isNotEmpty && !query.status.contains(EVideoStatus.active)) {
      return;
    }

    final newQuery = VideoQueryModel.fromJson(jsonDecode(jsonEncode(query.toJson())));
    newQuery.status.clear();
    newQuery.status.add(EVideoStatus.active);

    final response = await videoClient.queryVideo(0, 999, newQuery);
    if (response?.data != null) {
      setState(() {
        playlist.addAll(response?.data?.data ?? []);
      });
    }
  }
}
