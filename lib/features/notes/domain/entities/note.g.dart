// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Note _$NoteFromJson(Map<String, dynamic> json) => _Note(
  id: json['id'] as String,
  projectId: json['projectId'] as String?,
  title: json['title'] as String,
  content: json['content'] as String,
  category: json['category'] as String?,
  tags: json['tags'] as String?,
  pinned: json['pinned'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  userId: json['userId'] as String,
);

Map<String, dynamic> _$NoteToJson(_Note instance) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'title': instance.title,
  'content': instance.content,
  'category': instance.category,
  'tags': instance.tags,
  'pinned': instance.pinned,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'userId': instance.userId,
};
