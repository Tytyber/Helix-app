import 'package:json_annotation/json_annotation.dart';

part 'hub.g.dart';

@JsonSerializable()
class Hub {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Hub({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    required this.createdAt,
  });

  factory Hub.fromJson(Map<String, dynamic> json) => _$HubFromJson(json);
  Map<String, dynamic> toJson() => _$HubToJson(this);
}