
import 'package:json_annotation/json_annotation.dart';

part 'poster_entity.g.dart';

@JsonSerializable(nullable: false)
class Poster {
  String text;
  String url;
  String backgroundPicUrl;
  String iconUrl;

  Poster(this.text, this.url, this.backgroundPicUrl, this.iconUrl);

  factory Poster.fromJson(Map<String, dynamic> json) => _$PosterFromJson(json);

  Map<String, dynamic> toJson() => _$PosterToJson(this);
}