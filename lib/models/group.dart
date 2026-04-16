import 'package:json_annotation/json_annotation.dart';
part 'group.g.dart';

@JsonSerializable()
class Group {
  final String id;
  final String name;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}