import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';
import 'package:memento/core/theme/app_spacing.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class NoteDetailsScreen extends ConsumerWidget {
  final String noteId;

  const NoteDetailsScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);
    final theme = Theme.of(context);

    return notesState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Failed to load note: $e'))),
      data: (notes) {
        final note = notes.firstWhere(
          (n) => n.id == noteId,
          orElse: () => throw Exception('Note not found'),
        );

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(note.pinned ? Icons.push_pin : Icons.push_pin_outlined),
                color: note.pinned ? theme.colorScheme.primary : null,
                onPressed: () {
                   ref.read(notesProvider.notifier).updateNote(
                     note.copyWith(pinned: !note.pinned),
                   );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/notes/$noteId/edit', extra: note),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Updated ${DateFormat.yMMMd().format(note.updatedAt)} at ${DateFormat.jm().format(note.updatedAt)}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                MarkdownBody(
                  data: note.content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    h1: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    h2: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    h3: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
