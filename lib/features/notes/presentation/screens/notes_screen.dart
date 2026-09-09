import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/notes/domain/entities/note.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/core/widgets/memento_card.dart';
import 'package:memento/core/widgets/memento_state_views.dart';
import 'package:memento/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: notesState.when(
        loading: () => const MementoLoadingState(message: 'Loading knowledge...'),
        error: (e, _) => MementoErrorState(
          description: 'Could not load your notes.',
          onRetry: () => ref.read(notesProvider.notifier).loadNotes(),
        ),
        data: (notes) {
          if (notes.isEmpty) {
            return MementoEmptyState(
              title: 'Your second brain is empty',
              description: 'Capture your first idea or note.',
              icon: Icons.lightbulb_outline,
              action: ElevatedButton.icon(
                onPressed: () => _showCreateNoteDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('New Note'),
              ),
            );
          }
          
          final pinnedNotes = notes.where((n) => n.pinned).toList();
          final otherNotes = notes.where((n) => !n.pinned).toList();

          return CustomScrollView(
            slivers: [
              if (pinnedNotes.isNotEmpty) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.s),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Icon(Icons.push_pin, size: 16, color: theme.colorScheme.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Pinned',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  sliver: _buildGrid(pinnedNotes, context),
                ),
              ],
              if (otherNotes.isNotEmpty) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xl, AppSpacing.l, AppSpacing.s),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Recent Notes',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  sliver: _buildGrid(otherNotes, context),
                ),
              ],
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateNoteDialog(context, ref),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildGrid(List<Note> notes, BuildContext context) {
    // Determine cross axis count based on screen width
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (width > 600) crossAxisCount = 3;
    if (width > 1024) crossAxisCount = 4;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.m,
        crossAxisSpacing: AppSpacing.m,
        childAspectRatio: 0.85,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _NoteCard(note: notes[index]),
        childCount: notes.length,
      ),
    );
  }

  void _showCreateNoteDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title', hintText: 'e.g. Meeting Notes'),
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content', hintText: 'Start typing...'),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty || contentController.text.trim().isEmpty) return;
                
                final user = ref.read(authStateProvider.notifier).currentUser;
                if (user != null) {
                  final newNote = Note(
                    id: const Uuid().v4(),
                    title: titleController.text.trim(),
                    content: contentController.text.trim(),
                    pinned: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    userId: user.uid,
                  );
                  ref.read(notesProvider.notifier).addNote(newNote);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _NoteCard extends ConsumerWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return MementoCard(
      padding: const EdgeInsets.all(AppSpacing.m),
      onTap: () {
        // Show edit dialog or detail screen
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_horiz, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                onSelected: (value) {
                  if (value == 'delete') {
                    ref.read(notesProvider.notifier).deleteNote(note.id);
                  } else if (value == 'pin') {
                    ref.read(notesProvider.notifier).updateNote(
                      note.copyWith(pinned: !note.pinned),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pin',
                    child: Row(
                      children: [
                        Icon(note.pinned ? Icons.push_pin_outlined : Icons.push_pin, size: 20),
                        const SizedBox(width: 8),
                        Text(note.pinned ? 'Unpin' : 'Pin'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [Icon(Icons.delete_outline, color: Colors.red, size: 20), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: Text(
              note.content,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            DateFormat('MMM d, y').format(note.updatedAt),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
