import 'package:json_annotation/json_annotation.dart';

part 'card_entity.g.dart';

@JsonSerializable()
class PostPicture {
  String middlePicUrl;

  PostPicture(this.middlePicUrl);

  factory PostPicture.fromJson(Map<String, dynamic> json) => _$PostPictureFromJson(json);

  Map<String, dynamic> toJson() => _$PostPictureToJson(this);
}

@JsonSerializable()
class OriginalPost {
  String id;
  String type;
  String content;
  List<PostPicture> pictures;

  OriginalPost(this.id, this.type, this.content);

  factory OriginalPost.fromJson(Map<String, dynamic> json) => _$OriginalPostFromJson(json);

  Map<String, dynamic> toJson() => _$OriginalPostToJson(this);
}

@JsonSerializable()
class CardEntity {

  String id;

  String type;

  OriginalPost originalPost;

  String get picUrl => originalPost != null && originalPost.pictures != null && originalPost.pictures.length > 0 ? originalPost.pictures[0].middlePicUrl : '' ;

  String get text => originalPost != null ? originalPost.content : '';

  CardEntity(this.id, this.type, this.originalPost);

  factory CardEntity.fromJson(Map<String, dynamic> json) => _$CardEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CardEntityToJson(this);
}