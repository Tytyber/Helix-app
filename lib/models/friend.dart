import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
part 'friend.g.dart';

@JsonSerializable()
class FriendRequest {
  final String id;
  @JsonKey(name: 'from_user_id')
  final String fromUserId;
  @JsonKey(name: 'to_user_id')
  final String toUserId;
  final String status; // "pending", "accepted", "rejected"
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final User? fromUser; // может быть включён в ответ API

  FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
    this.fromUser,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);
}

@JsonSerializable()
class Friend {
  final String id;
  final String username;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? status;

  Friend({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.status,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
}