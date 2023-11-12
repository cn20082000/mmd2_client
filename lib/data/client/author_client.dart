import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/base_model.dart';

class AuthorClient extends BaseClient {
  Future<BaseModel<AuthorModel>?> createAuthor(AuthorModel body) async {
    try {
      final response = await dio.post("/author", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => AuthorModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<AuthorModel>>?> getPagingAuthor() async {
    try {
      final response = await dio.post("/author/paging", data: {
        "pageIndex": 0,
        "pageSize": 9999,
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => AuthorModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<AuthorModel>?> updateAuthor(AuthorModel body) async {
    try {
      final response = await dio.put("/author", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => AuthorModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<AuthorModel>?> previewAuthor(AuthorModel body) async {
    try {
      final response = await dio.post("/author/preview", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => AuthorModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<AuthorModel>?> syncVideo(AuthorModel body) async {
    try {
      final response = await dio.post("/author/sync", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => AuthorModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}
