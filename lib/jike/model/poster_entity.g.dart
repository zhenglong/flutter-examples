// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poster_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poster _$PosterFromJson(Map<String, dynamic> json) {
  return Poster(json['text'] as String, json['url'] as String,
      json['backgroundPicUrl'] as String, json['iconUrl'] as String);
}

Map<String, dynamic> _$PosterToJson(Poster instance) => <String, dynamic>{
      'text': instance.text,
      'url': instance.url,
      'backgroundPicUrl': instance.backgroundPicUrl,
      'iconUrl': instance.iconUrl
    };
