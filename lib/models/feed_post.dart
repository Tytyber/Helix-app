import 'package:json_annotation/json_annotation.dart';
part 'feed_post.g.dart';

@JsonSerializable()
class FeedPost {
  final String id;
  @JsonKey(name: 'hub_id')
  final String hubId;
  @JsonKey(name: 'hub_name')
  final String hubName;
  @JsonKey(name: 'author_id')
  final String authorId;
  final String content;
  final int likes;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  FeedPost({
    required this.id,
    required this.hubId,
    required this.hubName,
    required this.authorId,
    required this.content,
    required this.likes,
    required this.createdAt,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) => _$FeedPostFromJson(json);
  Map<String, dynamic> toJson() => _$FeedPostToJson(this);
}