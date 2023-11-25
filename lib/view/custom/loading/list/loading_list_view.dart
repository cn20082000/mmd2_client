import 'package:flutter/material.dart';
import 'package:mmd2/view/custom/loading/list/loading_list_controller.dart';
import 'package:mmd2/view/custom/loading/view/loading_screen.dart';

class LoadingListView extends StatefulWidget {
  final LoadingListController controller;
  final Widget Function(BuildContext context, int index, dynamic item) itemBuilder;
  final ELoadingListType type;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;

  const LoadingListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.type = ELoadingListType.separated,
    this.scrollDirection = Axis.vertical,
    this.padding = const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 64),
  });

  factory LoadingListView.separated({
    Key? key,
    required LoadingListController controller,
    required Widget Function(BuildContext context, int index, dynamic item) itemBuilder,
    Axis scrollDirection = Axis.vertical,
    EdgeInsetsGeometry? padding = const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 64),
  }) =>
      LoadingListView(
        key: key,
        controller: controller,
        itemBuilder: itemBuilder,
        type: ELoadingListType.separated,
        scrollDirection: scrollDirection,
        padding: padding,
      );

  factory LoadingListView.wrap({
    Key? key,
    required LoadingListController controller,
    required Widget Function(BuildContext context, int index, dynamic item) itemBuilder,
    Axis scrollDirection = Axis.vertical,
    EdgeInsetsGeometry? padding = const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 64),
  }) =>
      LoadingListView(
        key: key,
        controller: controller,
        itemBuilder: itemBuilder,
        type: ELoadingListType.wrap,
        scrollDirection: scrollDirection,
        padding: padding,
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
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      itemCount: controller.data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4, width: 4),
      itemBuilder: (ctx, index) => widget.itemBuilder.call(ctx, index, controller.data[index]),
    );
  }

  Widget _buildListWrap(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      child: Wrap(
        direction: widget.scrollDirection == Axis.vertical ? Axis.horizontal : Axis.vertical,
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
