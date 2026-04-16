import 'package:json_annotation/json_annotation.dart';
part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final String id;
  @JsonKey(name: 'user1_id')
  final String user1Id;
  @JsonKey(name: 'user2_id')
  final String user2Id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
