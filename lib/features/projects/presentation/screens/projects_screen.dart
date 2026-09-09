import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/projects/domain/entities/project.dart';
import 'package:memento/features/projects/presentation/providers/project_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/core/widgets/memento_card.dart';
import 'package:memento/core/widgets/memento_state_views.dart';
import 'package:memento/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspaces', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: projectsState.when(
        loading: () => const MementoLoadingState(message: 'Loading workspaces...'),
        error: (e, _) => MementoErrorState(
          description: 'Could not load your workspaces.',
          onRetry: () => ref.read(projectsProvider.notifier).loadProjects(),
        ),
        data: (projects) {
          if (projects.isEmpty) {
            return MementoEmptyState(
              title: 'No workspaces yet',
              description: 'Create a new project to start organizing your work.',
              icon: Icons.folder_open_outlined,
              action: ElevatedButton.icon(
                onPressed: () => _showCreateProjectDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('New Workspace'),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.l),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
            itemBuilder: (context, index) {
              final project = projects[index];
              return _ProjectCard(project: project);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProjectDialog(context, ref),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('New Workspace'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Workspace Name', hintText: 'e.g. Q3 Launch'),
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 3,
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
                if (nameController.text.trim().isEmpty) return;
                
                final user = ref.read(authStateProvider.notifier).currentUser;
                if (user != null) {
                  final newProject = Project(
                    id: const Uuid().v4(),
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    userId: user.uid,
                  );
                  ref.read(projectsProvider.notifier).addProject(newProject);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return MementoCard(
      withAccent: true,
      onTap: () {
        // In the future: navigate to project details
      },
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                onSelected: (value) {
                  if (value == 'delete') {
                    ref.read(projectsProvider.notifier).deleteProject(project.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [Icon(Icons.edit_outlined, size: 20), SizedBox(width: 8), Text('Edit')],
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
          if (project.description != null && project.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            Text(
              project.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.m),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Updated ${DateFormat.yMMMd().format(project.updatedAt)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const Spacer(),
              if (project.progress != null && project.progress! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadii.s),
                  ),
                  child: Text(
                    '${(project.progress! * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
