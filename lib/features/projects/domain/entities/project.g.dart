// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  category: json['category'] as String?,
  priority: json['priority'] as String?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  userId: json['userId'] as String,
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'category': instance.category,
  'priority': instance.priority,
  'startDate': instance.startDate?.toIso8601String(),
  'deadline': instance.deadline?.toIso8601String(),
  'progress': instance.progress,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'userId': instance.userId,
};
