import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:memento/features/notes/domain/entities/note.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: notesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notes) {
          if (notes.isEmpty) return const Center(child: Text('No notes yet.'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                child: ExpansionTile(
                  title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Last updated: ${note.updatedAt.toLocal().toString().split('.')[0]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => ref.read(notesProvider.notifier).deleteNote(note.id),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MarkdownBody(data: note.content),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = ref.read(authStateProvider.notifier).currentUser;
          if (user == null) return;
          final newNote = Note(
            id: const Uuid().v4(),
            title: 'New Note',
            content: '# New Note\n\nThis is a markdown note.',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: user.uid,
          );
          ref.read(notesProvider.notifier).addNote(newNote);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
