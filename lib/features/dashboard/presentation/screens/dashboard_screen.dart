import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/features/projects/presentation/providers/project_provider.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider.notifier).currentUser;
    final projectsState = ref.watch(projectsProvider);
    final tasksState = ref.watch(tasksProvider);
    final notesState = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${user?.displayName ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Projects', () => context.push('/projects')),
            const SizedBox(height: 8),
            _buildProjectsSection(projectsState),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Tasks', () => context.push('/tasks')),
            const SizedBox(height: 8),
            _buildTasksSection(tasksState),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Notes', () => context.push('/notes')),
            const SizedBox(height: 8),
            _buildNotesSection(notesState),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: onSeeAll, child: const Text('See All')),
      ],
    );
  }

  Widget _buildProjectsSection(AsyncValue projectsState) {
    return projectsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (projects) {
        if (projects.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No active projects. Create one!'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length > 3 ? 3 : projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Card(
              child: ListTile(
                title: Text(project.name),
                subtitle: Text(project.description ?? 'No description'),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTasksSection(AsyncValue tasksState) {
    return tasksState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No pending tasks. You\'re all caught up!'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length > 5 ? 5 : tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              child: ListTile(
                leading: Icon(task.status == 'completed' ? Icons.check_circle : Icons.radio_button_unchecked),
                title: Text(task.title),
                subtitle: Text(task.priority ?? 'No priority'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotesSection(AsyncValue notesState) {
    return notesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (notes) {
        if (notes.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No notes yet. Capture your thoughts!'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notes.length > 3 ? 3 : notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Card(
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(
                  note.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        );
      },
    );
  }
}
