import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/world_model.dart';

class CharacterModel extends IToJson {
  String? id;
  String? name;
  String? url;
  String? description;
  WorldModel? world;

  CharacterModel({this.id, this.name, this.url, this.description, this.world});

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json["id"] as String?,
        name: json["name"] as String?,
        url: json["url"] as String?,
        description: json["description"] as String?,
        world: json["world"] is Map<String, dynamic> ? WorldModel.fromJson(json["world"]) : null,
      );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
        "id": id,
        "name": name,
        "url": url,
        "description": description,
        "world": world?.toJson(includeNullValue: includeNullValue)
      }..removeWhere((key, value) => includeNullValue ? false : value == null);
}
