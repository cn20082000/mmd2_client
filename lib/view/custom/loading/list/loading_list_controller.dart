import 'package:flutter/widgets.dart';
import 'package:mmd2/view/custom/loading/view/loading_controller.dart';

class LoadingListController extends LoadingController {
  final List _data = [];
  final int _pageSize;
  int _pageIndex = 0;
  int _lastPageSize = 0;

  final ScrollController _scrollCtrl = ScrollController();
  Future<List> Function(int pageIndex, int pageSize)? _getData;

  LoadingListController(this._pageSize);

  void reload() async {
    scrollController.removeListener(_scrollListener);
    if (scrollController.hasClients) {
      await scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
    loading = true;

    _pageIndex = 0;
    final response = await _getData?.call(_pageIndex, _pageSize);
    data.clear();
    data.addAll(response ?? []);
    _lastPageSize = response?.length ?? 0;

    loading = false;
    scrollController.addListener(_scrollListener);
  }

  void loadMore() async {
    loading = true;

    _pageIndex += 1;
    final response = await _getData?.call(_pageIndex, _pageSize);
    data.addAll(response ?? []);
    _lastPageSize = response?.length ?? 0;

    loading = false;
  }

  void _scrollListener() {
    if (_lastPageSize >= _pageSize && _scrollCtrl.position.extentAfter < 500 && !loading) {
      loadMore();
    }
  }

  List get data => _data;

  ScrollController get scrollController => _scrollCtrl;

  set getData(Future<List> Function(int pageIndex, int pageSize) value) => _getData = value;
}
