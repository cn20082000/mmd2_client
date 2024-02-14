import 'package:flutter/material.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/client/video_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_video/query_video/widgets/video_form_view.dart';
import 'package:mmd2/view/section_video/query_video/widgets/video_item_view.dart';

class AuthorVideoView extends StatefulWidget {
  final AuthorModel author;

  const AuthorVideoView({super.key, required this.author});

  @override
  State<AuthorVideoView> createState() => _AuthorVideoViewState();
}

class _AuthorVideoViewState extends State<AuthorVideoView> {
  final videoClient = VideoClient();
  final authorClient = AuthorClient();

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
              widget.author.name ?? "",
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
      floatingButton: LoadingView(
        controller: loadingCtrl,
        builder: (loading) => FloatingActionButton(
          onPressed: loading ? null : _syncVideo,
          tooltip: "Sync videos",
          child: const Icon(Icons.download),
        ),
      ),
      body: LoadingListView.separated(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => VideoItemView(
          item: item,
          onEdit: () {
            VideoFormView(
              title: "Edit video",
              item: item,
              onDone: (video) => _updateVideo(video),
            ).showAsDialog(context);
          },
        ),
      ),
    );
  }

  Future<List<VideoModel>> _getData(int pageIndex, int pageSize) async {
    final result = <VideoModel>[];

    final response = await App.uc.video.getPagingByAuthor.invoke(pageIndex, pageSize, widget.author);

    if (response?.data != null) {
      result.addAll((response?.data?.data ?? []));
    }

    return result;
  }

  Future<void> _syncVideo() async {
    loadingCtrl.loading = true;
    final response = await App.uc.author.syncVideo.invoke(widget.author);
    loadingCtrl.loading = false;

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _updateVideo(VideoModel video) async {
    final response = await App.uc.video.update.invoke(video);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }
}
