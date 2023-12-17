import 'package:mmd2/data/client/author_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/base_model.dart';

class GetPagingAuthorUC {
  Future<BaseModel<PagingModel<AuthorModel>>?> invoke(int pageIndex, int pageSize) {
    return AuthorClient().getPagingAuthor(pageIndex, pageSize);
  }
}