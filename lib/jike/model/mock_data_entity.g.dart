// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseDataEntity _$ResponseDataEntityFromJson(Map<String, dynamic> json) {
  return ResponseDataEntity(json['data'] == null
      ? null
      : MockDataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ResponseDataEntityToJson(ResponseDataEntity instance) =>
    <String, dynamic>{'data': instance.data};

MockDataEntity _$MockDataEntityFromJson(Map<String, dynamic> json) {
  return MockDataEntity(
      (json['toolbarItems'] as List)
          ?.map((e) => e == null
              ? null
              : ToolbarItemEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['posters'] as List)
          ?.map((e) =>
              e == null ? null : Poster.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['cards'] as List)
          ?.map((e) =>
              e == null ? null : CardEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$MockDataEntityToJson(MockDataEntity instance) =>
    <String, dynamic>{
      'toolbarItems': instance.toolbarItems,
      'posters': instance.posters,
      'cards': instance.cards
    };
