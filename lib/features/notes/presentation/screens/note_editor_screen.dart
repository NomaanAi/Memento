import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/features/notes/domain/entities/note.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/core/theme/app_spacing.dart';
import 'package:uuid/uuid.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? note;
  final String? noteId;

  const NoteEditorScreen({super.key, this.note, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  
  Note? _currentNote;
  bool _pinned = false;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentNote == null && widget.noteId != null) {
      final notes = ref.read(notesProvider).value;
      if (notes != null) {
        _currentNote = notes.where((n) => n.id == widget.noteId).firstOrNull;
      }
    }
    if (_currentNote != null) {
      _titleController = TextEditingController(text: _currentNote!.title);
      _contentController = TextEditingController(text: _currentNote!.content);
      _pinned = _currentNote!.pinned;
    } else {
      _titleController = TextEditingController(text: '');
      _contentController = TextEditingController(text: '');
      _pinned = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider.notifier).currentUser;
    if (user == null) return;

    if (_currentNote == null) {
      // Create
      final newNote = Note(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        pinned: _pinned,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: user.uid,
      );
      ref.read(notesProvider.notifier).addNote(newNote);
    } else {
      // Update
      final updatedNote = _currentNote!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        pinned: _pinned,
        updatedAt: DateTime.now(),
      );
      ref.read(notesProvider.notifier).updateNote(updatedNote);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _currentNote != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: Icon(_pinned ? Icons.push_pin : Icons.push_pin_outlined),
            color: _pinned ? theme.colorScheme.primary : null,
            onPressed: () {
              setState(() {
                _pinned = !_pinned;
              });
            },
          ),
          TextButton(
            onPressed: _saveNote,
            child: const Text('Save'),
          ),
          const SizedBox(width: AppSpacing.s),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, 0),
              child: TextFormField(
                controller: _titleController,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  border: InputBorder.none,
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Title is required' : null,
              ),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                child: TextFormField(
                  controller: _contentController,
                  style: theme.textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Start writing... (Markdown supported)',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
