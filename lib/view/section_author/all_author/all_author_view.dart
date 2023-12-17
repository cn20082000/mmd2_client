import 'package:flutter/material.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_author/all_author/widgets/author_form_view.dart';
import 'package:mmd2/view/section_author/all_author/widgets/author_item_view.dart';
import 'package:mmd2/view/section_author/author_video/author_video_view.dart';

class AllAuthorView extends StatefulWidget {
  const AllAuthorView({super.key});

  @override
  State<AllAuthorView> createState() => _AllAuthorViewState();
}

class _AllAuthorViewState extends State<AllAuthorView> {
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
            Text(
              "Authors",
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
          AuthorFormView(
            title: "Add new author",
            onDone: (author) => _createAuthor(author),
          ).showAsDialog(context);
        },
        tooltip: "Add new author",
        child: const Icon(Icons.add),
      ),
      body: LoadingListView.wrap(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => AuthorItemView(
          item: item,
          onEdit: () {
            AuthorFormView(
              title: "Update author",
              item: item,
              onDone: (author) => _updateAuthor(author),
            ).showAsDialog(context);
          },
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuthorVideoView(author: item)));
          },
        ),
      ),
    );
  }

  Future<List<AuthorModel>> _getData(int pageIndex, int pageSize) async {
    final result = <AuthorModel>[];

    final response = await App.uc.author.getPagingAuthor.invoke(pageIndex, pageSize);
    if (response?.data != null) {
      result.addAll(response?.data?.data ?? []);
    }

    return result;
  }

  Future<void> _createAuthor(AuthorModel author) async {
    final response = await App.uc.author.createAuthor.invoke(author);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _updateAuthor(AuthorModel author) async {
    final response = await App.uc.author.updateAuthor.invoke(author);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }
}
