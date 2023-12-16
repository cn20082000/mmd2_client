import 'package:mmd2/data/enumi/e_orientation.dart';
import 'package:mmd2/data/enumi/e_video_status.dart';
import 'package:mmd2/data/model/action_model.dart';
import 'package:mmd2/data/model/author_model.dart';
import 'package:mmd2/data/model/base_model.dart';
import 'package:mmd2/data/model/character_model.dart';
import 'package:mmd2/data/model/song_model.dart';
import 'package:mmd2/util/extension/list_ext.dart';

class VideoQueryModel extends IToJson {
  String? name;
  List<EOrientation> orientations = [];
  List<EVideoStatus> status = [];
  List<AuthorModel> authors = [];
  List<SongModel> songs = [];
  List<CharacterModel> characters = [];
  List<ActionModel> actions = [];

  VideoQueryModel(
      {this.name,
      this.orientations = const [],
      this.status = const [],
      this.authors = const [],
      this.songs = const [],
      this.characters = const [],
      this.actions = const []});

  factory VideoQueryModel.fromJson(Map<String, dynamic> json) => VideoQueryModel(
        name: json["name"] as String?,
        orientations: (json["orientations"] as List?)?.compactMap((e) => EOrientation.enumOf(e)) ?? [],
        status: (json["status"] as List?)?.compactMap((e) => EVideoStatus.enumOf(e)) ?? [],
        authors: (json["authors"] as List?)?.compactMap((e) => AuthorModel.fromJson(e)) ?? [],
        songs: (json["songs"] as List?)?.compactMap((e) => SongModel.fromJson(e)) ?? [],
        characters: (json["characters"] as List?)?.compactMap((e) => CharacterModel.fromJson(e)) ?? [],
        actions: (json["actions"] as List?)?.compactMap((e) => ActionModel.fromJson(e)) ?? [],
      );

  @override
  Map<String, dynamic> toJson({bool includeNullValue = false}) => {
        "name": name,
        "orientations": orientations.map((e) => e.value).toList(),
        "status": status.map((e) => e.value).toList(),
        "authors": authors.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
        "songs": songs.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
        "characters": characters.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
        "actions": actions.map((e) => e.toJson(includeNullValue: includeNullValue)).toList(),
      }..removeWhere((key, value) => includeNullValue ? false : value == null);
}
