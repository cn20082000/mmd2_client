import 'package:mmd2/data/model/base_model.dart';

class WorldModel extends IToJson {
  String? id;
  String? name;
  String? description;

  WorldModel({this.id, this.name, this.description});

  factory WorldModel.fromJson(Map<String, dynamic> json) => WorldModel(
        id: json["id"] as String?,
        name: json["name"] as String?,
        description: json["description"] as String?,
      );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
        "id": id,
        "name": name,
        "description": description,
      }..removeWhere((key, value) => includeNullValue ? false : value == null);
}
