import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/features/notes/data/repositories/note_repository.dart';
import 'package:memento/features/notes/domain/entities/note.dart';
import 'package:memento/core/database/database_helper.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository(DatabaseHelper.instance);
});

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  NoteRepository get _repository => ref.read(noteRepositoryProvider);
  String get _userId => ref.read(authStateProvider.notifier).currentUser?.uid ?? '';

  @override
  FutureOr<List<Note>> build() async {
    if (_userId.isEmpty) return [];
    return _repository.getNotes(_userId);
  }

  Future<void> loadNotes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getNotes(_userId));
  }

  Future<void> addNote(Note note) async {
    await _repository.createNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _repository.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
    await loadNotes();
  }
}

