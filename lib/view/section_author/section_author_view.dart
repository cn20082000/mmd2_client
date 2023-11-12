import 'package:flutter/material.dart';
import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_author/author_video/author_video_view.dart';
import 'package:mmd2/view/section_author/widgets/author_form_view.dart';
import 'package:mmd2/view/section_author/widgets/author_item_view.dart';

class SectionAuthorView extends StatefulWidget {
  const SectionAuthorView({super.key});

  @override
  State<SectionAuthorView> createState() => _SectionAuthorViewState();
}

class _SectionAuthorViewState extends State<SectionAuthorView> {
  final authorClient = AuthorClient();

  bool isLoading = false;
  final authorList = <AuthorModel>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(builder: (ctx) => _buildScreen(ctx));
  }

  Widget _buildScreen(BuildContext context) {
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
            IconButton(
              tooltip: "Refresh",
              onPressed: isLoading ? null : _reloadData,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      floatingButton: FloatingActionButton(
        onPressed: () {
          AuthorFormView(
            title: "Add new author",
            onPreview: _previewAuthor,
            onDone: (author) => _createAuthor(author),
          ).showAsDialog(context);
        },
        tooltip: "Add new author",
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLoading) const LinearProgressIndicator(minHeight: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 64,
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  authorList.length,
                  (index) => AuthorItemView(
                    item: authorList[index],
                    onEdit: () {
                      AuthorFormView(
                        title: "Update author",
                        item: authorList[index],
                        onPreview: _previewAuthor,
                        onDone: (author) => _updateAuthor(author),
                      ).showAsDialog(context);
                    },
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuthorVideoView(author: authorList[index])));
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _reloadData() async {
    setState(() {
      isLoading = true;
    });
    final response = await authorClient.getPagingAuthor();
    if (response?.data != null) {
      authorList.clear();
      authorList.addAll(response?.data?.data ?? []);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<AuthorModel?> _previewAuthor(AuthorModel author) async {
    final response = await authorClient.previewAuthor(author);

    return response?.data;
  }

  Future<void> _createAuthor(AuthorModel author) async {
    final response = await authorClient.createAuthor(author);

    if (response?.data != null) {
      _reloadData();
    }
  }

  Future<void> _updateAuthor(AuthorModel author) async {
    final response = await authorClient.updateAuthor(author);

    if (response?.data != null) {
      _reloadData();
    }
  }
}
