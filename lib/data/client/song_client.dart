import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/producer_model.dart';
import 'package:mmd2/data/model/song_model.dart';

class SongClient extends BaseClient {
  Future<BaseModel<PagingModel<ProducerModel>>?> getPagingProducer() async {
    try {
      final response = await dio.post("/producer/paging", data: {
        "pageIndex": 0,
        "pageSize": 9999,
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => ProducerModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<SongModel>?> createSong(SongModel body) async {
    try {
      final response = await dio.post("/song", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => SongModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<SongModel>>?> getPagingSong() async {
    try {
      final response = await dio.post("/song/paging", data: {
        "pageIndex": 0,
        "pageSize": 9999,
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => SongModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<SongModel>?> updateSong(SongModel body) async {
    try {
      final response = await dio.put("/song", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => SongModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}
