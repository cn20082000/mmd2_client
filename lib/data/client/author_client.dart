import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/base_model.dart';

class AuthorClient extends BaseClient {
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
}
