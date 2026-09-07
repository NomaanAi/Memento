import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/features/projects/presentation/providers/project_provider.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider).value ?? [];
    final tasks = ref.watch(tasksProvider).value ?? [];
    final notes = ref.watch(notesProvider).value ?? [];

    final q = _query.toLowerCase();
    final filteredProjects = q.isEmpty ? [] : projects.where((p) => p.name.toLowerCase().contains(q) || (p.description?.toLowerCase().contains(q) ?? false)).toList();
    final filteredTasks = q.isEmpty ? [] : tasks.where((t) => t.title.toLowerCase().contains(q) || (t.description?.toLowerCase().contains(q) ?? false)).toList();
    final filteredNotes = q.isEmpty ? [] : notes.where((n) => n.title.toLowerCase().contains(q) || n.content.toLowerCase().contains(q)).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search projects, tasks, notes...',
            border: InputBorder.none,
          ),
          onChanged: (val) {
            setState(() {
              _query = val;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _query = '';
              });
            },
          ),
        ],
      ),
      body: _query.isEmpty
          ? const Center(child: Text('Type to search'))
          : (filteredProjects.isEmpty && filteredTasks.isEmpty && filteredNotes.isEmpty)
              ? const Center(child: Text('No results found.'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (filteredProjects.isNotEmpty) ...[
                      Text('Projects', style: Theme.of(context).textTheme.titleMedium),
                      ...filteredProjects.map((p) => ListTile(
                        leading: const Icon(Icons.folder),
                        title: Text(p.name),
                        onTap: () => context.push('/projects'),
                      )),
                      const Divider(),
                    ],
                    if (filteredTasks.isNotEmpty) ...[
                      Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
                      ...filteredTasks.map((t) => ListTile(
                        leading: const Icon(Icons.task),
                        title: Text(t.title),
                        onTap: () => context.push('/tasks'),
                      )),
                      const Divider(),
                    ],
                    if (filteredNotes.isNotEmpty) ...[
                      Text('Notes', style: Theme.of(context).textTheme.titleMedium),
                      ...filteredNotes.map((n) => ListTile(
                        leading: const Icon(Icons.note),
                        title: Text(n.title),
                        onTap: () => context.push('/notes'),
                      )),
                    ],
                  ],
                ),
    );
  }
}
