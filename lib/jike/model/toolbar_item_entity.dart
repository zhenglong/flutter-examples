import 'package:json_annotation/json_annotation.dart';

part 'toolbar_item_entity.g.dart';

@JsonSerializable(nullable: false)
class ToolbarItemEntity {
  String url;
  String picUrl;
  String title;

  ToolbarItemEntity(this.url, this.picUrl, this.title);

  factory ToolbarItemEntity.fromJson(Map<String, dynamic> json) => _$ToolbarItemEntityFromJson(json);


  Map<String, dynamic> toJson() => _$ToolbarItemEntityToJson(this);
}