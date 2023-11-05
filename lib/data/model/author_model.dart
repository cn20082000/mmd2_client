import 'package:mmd2/common/constants.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/util/extension/date_ext.dart';

class AuthorModel extends IToJson {
  String? id;
  String? name;
  String? profileUrl;
  String? avatarUrl;
  String? description;
  bool? isAlive;
  DateTime? lastUpdated;
  int? videosCount;

  String? profileRelativeUrl;

  AuthorModel(
      {this.id,
      this.name,
      this.profileUrl,
      this.avatarUrl,
      this.description,
      this.isAlive,
      this.lastUpdated,
      this.videosCount,
      this.profileRelativeUrl});

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
        id: json["id"] as String?,
        name: json["name"] as String?,
        profileUrl: json["profileUrl"] as String?,
        avatarUrl: json["avatarUrl"] as String?,
        description: json["description"] as String?,
        isAlive: json["isAlive"] as bool?,
        lastUpdated: DateTime.tryParse(json["lastUpdated"] as String? ?? ""),
        videosCount: json["videosCount"] as int?,
        profileRelativeUrl: json["profileRelativeUrl"] as String?,
      );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
        "id": id,
        "name": name,
        "profileUrl": profileUrl,
        "avatarUrl": avatarUrl,
        "description": description,
        "isAlive": isAlive,
        "lastUpdated": lastUpdated?.format(Constants.serverDateTimeFormat),
        "videosCount": videosCount,
        "profileRelativeUrl": profileRelativeUrl,
      }..removeWhere((key, value) => includeNullValue ? false : value == null);
}
