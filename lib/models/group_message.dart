import 'package:json_annotation/json_annotation.dart';
part 'group_message.g.dart';

@JsonSerializable()
class GroupMessage {
  final String id;
  @JsonKey(name: 'group_id')
  final String groupId;
  @JsonKey(name: 'sender_id')
  final String senderId;
  final String content;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  GroupMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory GroupMessage.fromJson(Map<String, dynamic> json) => _$GroupMessageFromJson(json);
}