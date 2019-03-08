// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Email _$EmailFromJson(Map<String, dynamic> json) {
  return Email(
      json['body'] as String,
      json['title'] as String,
      json['sender'] == null
          ? null
          : User.fromJson(json['sender'] as Map<String, dynamic>),
      (json['receivers'] as List)
          ?.map((e) =>
              e == null ? null : User.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      sendTime: json['sendTime'] == null
          ? null
          : DateTime.parse(json['sendTime'] as String),
      priority: json['priority'] as int);
}

Map<String, dynamic> _$EmailToJson(Email instance) => <String, dynamic>{
      'body': instance.body,
      'title': instance.title,
      'sender': instance.sender,
      'receivers': instance.receivers,
      'sendTime': instance.sendTime?.toIso8601String(),
      'priority': instance.priority
    };
