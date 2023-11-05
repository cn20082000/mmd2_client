import 'package:flutter/material.dart';
import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/navigation/section_navigator.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_author/widgets/author_form_view.dart';

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
    // _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(builder: (ctx) => _buildScreen(ctx));
  }

  Widget _buildScreen(BuildContext context) {
    return SectionScreen(
      floatingButton: FloatingActionButton(
        onPressed: () {
          AuthorFormView(
            title: "Add new author",
            onPreview: _previewAuthor,
          ).showAsDialog(context);
        },
        tooltip: "Add new author",
        child: const Icon(Icons.add),
      ),
    );
  }

  // Future<void> _reloadData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final response = await authorClient.getPagingWorld();
  //   if (response?.data != null) {
  //     worldList.clear();
  //     worldList.addAll(response?.data?.data ?? []);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Future<AuthorModel?> _previewAuthor(AuthorModel author) async {
    final response = await authorClient.previewAuthor(author);

    return response?.data;
  }
}
