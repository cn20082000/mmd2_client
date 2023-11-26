import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/base_model.dart';

class ActionClient extends BaseClient {
  Future<BaseModel<ActionModel>?> createAction(ActionModel body) async {
    try {
      final response = await dio.post("/action", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => ActionModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<ActionModel>>?> getPagingAction(int pageIndex, int pageSize) async {
    try {
      final response = await dio.post("/action/paging", data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => ActionModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<ActionModel>?> updateAction(ActionModel body) async {
    try {
      final response = await dio.put("/action", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => ActionModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<ActionModel>>?> getAllActionLite() async {
    try {
      final response = await dio.post("/action/lite");

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => ActionModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}
