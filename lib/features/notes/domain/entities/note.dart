import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    String? projectId,
    required String title,
    required String content,
    String? category,
    String? tags,
    @Default(false) bool pinned,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
