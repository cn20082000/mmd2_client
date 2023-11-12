import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/util/enumi/e_orientation.dart';
import 'package:mmd2/util/enumi/e_video_status.dart';

class VideoModel extends IToJson {
  String? id;
  String? name;
  String? cloudUrl;
  String? localUrl;
  EOrientation? orientation;
  EVideoStatus? status;
  AuthorModel? author;
  List<SongModel>? songs;
  List<CharacterModel>? characters;
  List<ActionModel>? actions;

  VideoModel(
      {this.id, this.name, this.cloudUrl, this.localUrl, this.orientation, this.status, this.author, this.songs, this.characters, this.actions});

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["id"] as String?,
        name: json["name"] as String?,
        cloudUrl: json["cloudUrl"] as String?,
        localUrl: json["localUrl"] as String?,
        orientation: EOrientation.enumOf(json["orientation"] as String?),
        status: EVideoStatus.enumOf(json["status"] as String?),
        author: json["author"] is Map<String, dynamic> ? AuthorModel.fromJson(json["author"]) : null,
        songs: (json["songs"] as List?)?.map((e) => SongModel.fromJson(e as Map<String, dynamic>)).toList(),
        characters: (json["characters"] as List?)?.map((e) => CharacterModel.fromJson(e as Map<String, dynamic>)).toList(),
        actions: (json["actions"] as List?)?.map((e) => ActionModel.fromJson(e as Map<String, dynamic>)).toList(),
      );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
        "id": id,
        "name": name,
        "cloudUrl": cloudUrl,
        "localUrl": localUrl,
        "orientation": orientation?.value,
        "status": status?.value,
        "author": author?.toJson(includeNullValue: includeNullValue),
        "songs": songs?.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
        "characters": characters?.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
        "actions": actions?.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
      }..removeWhere((key, value) => includeNullValue ? false : value == null);
}
