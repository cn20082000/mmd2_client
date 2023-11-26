import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/world_model.dart';

class CharacterClient extends BaseClient {
  Future<BaseModel<WorldModel>?> createWorld(WorldModel body) async {
    try {
      final response = await dio.post("/world", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => WorldModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<WorldModel>>?> getPagingWorld(int pageIndex, int pageSize) async {
    try {
      final response = await dio.post("/world/paging", data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => WorldModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<WorldModel>?> updateWorld(WorldModel body) async {
    try {
      final response = await dio.put("/world", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => WorldModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<WorldModel>>?> getAllWorldLite() async {
    try {
      final response = await dio.post("/world/lite");

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => WorldModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<CharacterModel>>?> getPagingCharacterByWorld(WorldModel world, int pageIndex, int pageSize) async {
    try {
      final response = await dio.post("/character/by-world/paging", data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "data": world.toJson(),
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => CharacterModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<CharacterModel>?> createCharacter(CharacterModel body) async {
    try {
      final response = await dio.post("/character", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => CharacterModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<CharacterModel>>?> getPagingCharacter(int pageIndex, int pageSize) async {
    try {
      final response = await dio.post("/character/paging", data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => CharacterModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<CharacterModel>?> updateCharacter(CharacterModel body) async {
    try {
      final response = await dio.put("/character", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => CharacterModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<CharacterModel>>?> getAllCharacterLite() async {
    try {
      final response = await dio.post("/character/lite");

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => CharacterModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}
