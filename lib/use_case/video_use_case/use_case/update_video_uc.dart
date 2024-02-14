import 'package:mmd2/data/client/video_client.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/video_model.dart';

class UpdateVideoUC {
  Future<BaseModel<VideoModel>?> invoke(VideoModel body) {
    return VideoClient().updateVideo(body);
  }
}