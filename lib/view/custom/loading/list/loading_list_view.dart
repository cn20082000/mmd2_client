import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/view/loading_screen.dart';

class LoadingListView extends StatefulWidget {
  final LoadingListController controller;
  final Widget Function(BuildContext context, int index, dynamic item) itemBuilder;
  final ELoadingListType type;

  const LoadingListView({super.key, required this.controller, required this.itemBuilder, this.type = ELoadingListType.separated});

  factory LoadingListView.separated({key, required controller, required itemBuilder}) => LoadingListView(
        key: key,
        controller: controller,
        itemBuilder: itemBuilder,
        type: ELoadingListType.separated,
      );

  factory LoadingListView.wrap({key, required controller, required itemBuilder}) => LoadingListView(
        key: key,
        controller: controller,
        itemBuilder: itemBuilder,
        type: ELoadingListType.wrap,
      );

  @override
  State<LoadingListView> createState() => _LoadingListViewState();
}

class _LoadingListViewState extends State<LoadingListView> {
  LoadingListController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    widget.controller.listener = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      controller: controller,
      child: Builder(builder: (ctx) {
        switch (widget.type) {
          case ELoadingListType.separated:
            return _buildListSeparated(ctx);
          case ELoadingListType.wrap:
            return _buildListWrap(ctx);
        }
      }),
    );
  }

  Widget _buildListSeparated(BuildContext context) {
    return ListView.separated(
      controller: controller.scrollController,
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: 64,
      ),
      itemCount: controller.data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (ctx, index) => widget.itemBuilder.call(ctx, index, controller.data[index]),
    );
  }

  Widget _buildListWrap(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
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
          controller.data.length,
          (index) => widget.itemBuilder.call(context, index, controller.data[index]),
        ),
      ),
    );
  }
}

enum ELoadingListType {
  separated,
  wrap,
}
