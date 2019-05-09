// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPicture _$PostPictureFromJson(Map<String, dynamic> json) {
  return PostPicture(json['middlePicUrl'] as String);
}

Map<String, dynamic> _$PostPictureToJson(PostPicture instance) =>
    <String, dynamic>{'middlePicUrl': instance.middlePicUrl};

OriginalPost _$OriginalPostFromJson(Map<String, dynamic> json) {
  return OriginalPost(
      json['id'] as String, json['type'] as String, json['content'] as String)
    ..pictures = (json['pictures'] as List)
        ?.map((e) =>
            e == null ? null : PostPicture.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$OriginalPostToJson(OriginalPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'content': instance.content,
      'pictures': instance.pictures
    };

CardEntity _$CardEntityFromJson(Map<String, dynamic> json) {
  return CardEntity(
      json['id'] as String,
      json['type'] as String,
      json['originalPost'] == null
          ? null
          : OriginalPost.fromJson(
              json['originalPost'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CardEntityToJson(CardEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'originalPost': instance.originalPost
    };
