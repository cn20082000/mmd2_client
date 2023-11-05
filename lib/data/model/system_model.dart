import 'package:mmd2/data/model/base_model.dart';

class SystemModel extends IToJson {
  Map<String, String>? additionHeaders;

  SystemModel({this.additionHeaders});

  factory SystemModel.fromJson(Map<String, dynamic> json) => SystemModel(
    additionHeaders: (json["additionHeaders"] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, value.toString())),
  );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
    "additionHeaders": additionHeaders,
  }..removeWhere((key, value) => includeNullValue ? false : value == null);
}
