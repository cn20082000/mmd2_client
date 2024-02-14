import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/base_model.dart';

class SyncVideoUC {
  Future<BaseModel<AuthorModel>?> invoke(AuthorModel body) {
    return AuthorClient().syncVideo(body);
  }
}