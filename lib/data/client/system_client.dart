import 'package:flutter/foundation.dart';
import 'package:mmd2/data/client/base_client.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/system_model.dart';

class SystemClient extends BaseClient {
  Future<BaseModel<SystemModel>?> getSystem() async {
    try {
      final response = await dio.get("/system");

      return BaseModel.fromJson(
        response.data,
        (baseMap) => SystemModel.fromJson(baseMap),
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}
