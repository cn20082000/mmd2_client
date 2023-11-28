import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';

class VideoClient extends BaseClient {
  Future<BaseModel<VideoModel>?> updateVideo(VideoModel body) async {
    try {
      final response = await dio.put("/video", data: body.toJson());

      return BaseModel.fromJson(
        response.data,
        (baseMap) => VideoModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }

  Future<BaseModel<PagingModel<VideoModel>>?> queryVideo(int pageIndex, int pageSize, VideoQueryModel body) async {
    try {
      final response = await dio.post("/video/query", data: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "data": body.toJson(),
      });

      return BaseModel.fromJson(
        response.data,
        (baseMap) => PagingModel.fromJson(
          baseMap,
          (itemMap) => VideoModel.fromJson(itemMap),
        ),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}
