import 'package:json_annotation/json_annotation.dart';

part 'hub_post.g.dart';

@JsonSerializable()
class HubPost {
  final String id;
  @JsonKey(name: 'hub_id')
  final String hubId;
  @JsonKey(name: 'author_id')
  final String authorId;
  final String content;
  final int likes;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  HubPost({
    required this.id,
    required this.hubId,
    required this.authorId,
    required this.content,
    required this.likes,
    required this.createdAt,
  });

  factory HubPost.fromJson(Map<String, dynamic> json) => _$HubPostFromJson(json);
  Map<String, dynamic> toJson() => _$HubPostToJson(this);
}