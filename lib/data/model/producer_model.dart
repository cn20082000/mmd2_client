import 'package:mmd2/data/model/base_model.dart';

class ProducerModel extends IToJson {
  String? id;
  String? name;
  String? description;

  ProducerModel({this.id, this.name, this.description});

  factory ProducerModel.fromJson(Map<String, dynamic> json) => ProducerModel(
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
