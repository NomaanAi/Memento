import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/projects/domain/entities/project.dart';
import 'package:memento/features/projects/presentation/providers/project_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: projectsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(child: Text('No projects yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                child: ListTile(
                  title: Text(project.name),
                  subtitle: Text(project.description ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(projectsProvider.notifier).deleteProject(project.id);
                    },
                  ),
                  onTap: () {
                    // Update dummy
                    ref.read(projectsProvider.notifier).updateProject(
                      project.copyWith(description: 'Updated description'),
                    );
                  },
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
          final newProject = Project(
            id: const Uuid().v4(),
            name: 'New Project',
            description: 'A new project created at ${DateTime.now().toLocal()}',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: user.uid,
          );
          ref.read(projectsProvider.notifier).addProject(newProject);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
