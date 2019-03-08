import 'package:json_annotation/json_annotation.dart';
import './user.dart' ;

part 'mail.g.dart';

@JsonSerializable()
class Email {
  final String body;
  final String title;
  final User sender;
  final List<User> receivers;
  final DateTime sendTime;
  final int priority;

  Email(this.body, this.title, this.sender, this.receivers, {this.sendTime, this.priority});

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);

  Map<String, dynamic> toJson() => _$EmailToJson(this);
}