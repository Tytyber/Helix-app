import 'package:json_annotation/json_annotation.dart';
part 'call.g.dart';

enum CallStatus { pending, accepted, rejected, ended }

@JsonSerializable()
class Call {
  final String id;
  @JsonKey(name: 'caller_id')
  final String callerId;
  @JsonKey(name: 'callee_id')
  final String calleeId;
  final CallStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Call({
    required this.id,
    required this.callerId,
    required this.calleeId,
    required this.status,
    required this.createdAt,
  });

  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);
  Map<String, dynamic> toJson() => _$CallToJson(this);
}