import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:memento/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksProvider);
    final theme = Theme.of(context);

    return tasksState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Failed to load task: $e'))),
      data: (tasks) {
        final task = tasks.firstWhere(
          (t) => t.id == taskId,
          orElse: () => throw Exception('Task not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/tasks/$taskId/edit', extra: task),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: task.status == 'completed' 
                            ? theme.colorScheme.primaryContainer 
                            : theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.status?.toUpperCase() ?? 'PENDING',
                        style: TextStyle(
                          color: task.status == 'completed' 
                              ? theme.colorScheme.onPrimaryContainer 
                              : theme.colorScheme.onSecondaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    if (task.priority != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.priority!,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.l),
                Text(
                  task.title,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (task.dueDate != null) ...[
                  const SizedBox(height: AppSpacing.m),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: theme.colorScheme.error, size: 20),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        'Due ${DateFormat.yMMMd().format(task.dueDate!)}',
                        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.s),
                  Text(task.description!, style: theme.textTheme.bodyLarge),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
