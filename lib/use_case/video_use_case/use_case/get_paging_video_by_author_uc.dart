import 'package:mmd2/data/client/video_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/video_model.dart';
import 'package:mmd2/data/model/video_query_model.dart';

class GetPagingVideoByAuthorUC {
  Future<BaseModel<PagingModel<VideoModel>>?> invoke(int pageIndex, int pageSize, AuthorModel author) {
    return VideoClient().queryVideo(pageIndex, pageSize, VideoQueryModel(authors: [author]));
  }
}