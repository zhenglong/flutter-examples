

import 'package:flutter_app/jike/model/card_entity.dart';
import 'package:flutter_app/jike/model/poster_entity.dart';
import 'package:flutter_app/jike/model/toolbar_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mock_data_entity.g.dart';

@JsonSerializable()
class ResponseDataEntity {
  MockDataEntity data;

  ResponseDataEntity(this.data);

  factory ResponseDataEntity.fromJson(Map<String, dynamic> json) => _$ResponseDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDataEntityToJson(this);
}

@JsonSerializable()
class MockDataEntity {
  List<ToolbarItemEntity> toolbarItems;
  List<Poster> posters;
  List<CardEntity> cards;

  MockDataEntity(this.toolbarItems, this.posters, this.cards);

  factory MockDataEntity.fromJson(Map<String, dynamic> json) => _$MockDataEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MockDataEntityToJson(this);
}