import 'package:flutter/material.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_view.dart';
import 'package:mmd2/view/custom/loading/view/loading_view.dart';
import 'package:mmd2/view/custom/navigation/section_screen.dart';
import 'package:mmd2/view/section_action/all_action/widgets/action_form_view.dart';
import 'package:mmd2/view/section_action/all_action/widgets/action_item_view.dart';

class AllActionView extends StatefulWidget {
  const AllActionView({super.key});

  @override
  State<AllActionView> createState() => _AllActionViewState();
}

class _AllActionViewState extends State<AllActionView> {
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
              "Actions",
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
          ActionFormView(
            title: "Add new action",
            onDone: (action) => _createAction(action),
          ).showAsDialog(context);
        },
        tooltip: "Add new action",
        child: const Icon(Icons.add),
      ),
      body: LoadingListView.separated(
        controller: loadingCtrl,
        itemBuilder: (_, __, item) => ActionItemView(
          item: item,
          onEdit: () {
            ActionFormView(
              title: "Edit action",
              item: item,
              onDone: (action) => _updateAction(action),
            ).showAsDialog(context);
          },
        ),
      ),
    );
  }

  Future<List<ActionModel>> _getData(int pageIndex, int pageSize) async {
    final result = <ActionModel>[];

    final response = await App.uc.action.getPaging.invoke(pageIndex, pageSize);
    if (response?.data != null) {
      result.clear();
      result.addAll(response?.data?.data ?? []);
    }

    return result;
  }

  Future<void> _createAction(ActionModel action) async {
    final response = await App.uc.action.create.invoke(action);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }

  Future<void> _updateAction(ActionModel action) async {
    final response = await App.uc.action.update.invoke(action);

    if (response?.data != null) {
      loadingCtrl.reload();
    }
  }
}
