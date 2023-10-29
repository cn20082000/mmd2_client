import 'package:flutter/material.dart';
import 'package:mmd2/data/client/action_client.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/util/extension/widget_ext.dart';
import 'package:mmd2/view/action/action_form_view.dart';
import 'package:mmd2/view/action/action_item_view.dart';
import 'package:mmd2/view/custom/section_navigator.dart';
import 'package:mmd2/view/custom/section_screen.dart';

class ActionView extends StatefulWidget {
  const ActionView({super.key});

  @override
  State<ActionView> createState() => _ActionViewState();
}

class _ActionViewState extends State<ActionView> {
  final actionClient = ActionClient();

  bool isLoading = false;
  final actionList = <ActionModel>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return SectionNavigator(
      builder: (ctx) => _buildScreen(ctx),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return SectionScreen(
      appBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Actions",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
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
          ActionFormView(
            title: "Add new action",
            onDone: (action) => _createAction(action),
          ).showAsDialog(context);
        },
        tooltip: "Add new action",
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
              itemCount: actionList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (_, index) => ActionItemView(
                item: actionList[index],
                onEdit: () {
                  ActionFormView(
                    title: "Edit action",
                    item: actionList[index],
                    onDone: (action) => _updateAction(action),
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
    final response = await actionClient.getPagingAction();
    if (response?.data != null) {
      actionList.clear();
      actionList.addAll(response?.data?.data ?? []);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _createAction(ActionModel action) async {
    final response = await actionClient.createAction(action);

    if (response?.data != null) {
      _reloadData();
    }
  }

  Future<void> _updateAction(ActionModel action) async {
    final response = await actionClient.updateAction(action);

    if (response?.data != null) {
      _reloadData();
    }
  }
}
