// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppTask _$AppTaskFromJson(Map<String, dynamic> json) => _AppTask(
  id: json['id'] as String,
  projectId: json['projectId'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  priority: json['priority'] as String?,
  status: json['status'] as String?,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  userId: json['userId'] as String,
);

Map<String, dynamic> _$AppTaskToJson(_AppTask instance) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'title': instance.title,
  'description': instance.description,
  'priority': instance.priority,
  'status': instance.status,
  'dueDate': instance.dueDate?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'userId': instance.userId,
};
