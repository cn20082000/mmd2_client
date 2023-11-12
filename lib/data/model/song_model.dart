import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/producer_model.dart';

class SongModel extends IToJson {
  String? id;
  String? name;
  String? url;
  String? description;
  List<ProducerModel>? producers;

  SongModel({this.id, this.name, this.url, this.description, this.producers});

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        id: json["id"] as String?,
        name: json["name"] as String?,
        url: json["url"] as String?,
        description: json["description"] as String?,
        producers: (json["producers"] as List?)?.map((e) => ProducerModel.fromJson(e as Map<String, dynamic>)).toList(),
      );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
        "id": id,
        "name": name,
        "url": url,
        "description": description,
        "producers": producers?.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
      }..removeWhere((key, value) => includeNullValue ? false : value == null);
}
