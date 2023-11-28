import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/producer_model.dart';
import 'package:mmd2/data/model/song_model.dart';

class SongClient extends BaseClient {
  Future<BaseModel<ProducerModel>?> createProducer(ProducerModel body) async {
    try {
      final response = await dio.post("/producer", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => ProducerModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<ProducerModel>>?> getPagingProducer(int pageIndex, int pageSize) async {
    try {
      final response = await dio.post("/producer/paging", data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
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

  Future<BaseModel<ProducerModel>?> updateProducer(ProducerModel body) async {
    try {
      final response = await dio.put("/producer", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => ProducerModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<ProducerModel>>?> getAllProducerLite() async {
    try {
      final response = await dio.post("/producer/lite");

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

  Future<BaseModel<PagingModel<SongModel>>?> getPagingSong(int pageIndex, int pageSize) async {
    try {
      final response = await dio.post("/song/paging", data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
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

  Future<BaseModel<PagingModel<SongModel>>?> getAllSongLite() async {
    try {
      final response = await dio.post("/song/lite");

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
}
