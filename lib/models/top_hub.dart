import 'package:json_annotation/json_annotation.dart';
part 'top_hub.g.dart';

@JsonSerializable()
class TopHub {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final int members;

  TopHub({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    required this.members,
  });

  factory TopHub.fromJson(Map<String, dynamic> json) => _$TopHubFromJson(json);
}