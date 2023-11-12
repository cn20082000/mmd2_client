import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';

class VideoClient extends BaseClient {
  Future<BaseModel<PagingModel<VideoModel>>?> queryVideo(VideoQueryModel body) async {
    try {
      final response = await dio.post("/video/query", data: {
        "pageIndex": 0,
        "pageSize": 9999,
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
