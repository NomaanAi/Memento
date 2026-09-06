import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
abstract class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    String? description,
    String? category,
    String? priority,
    DateTime? startDate,
    DateTime? deadline,
    @Default(0.0) double progress,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}
