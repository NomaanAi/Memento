import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/tasks/domain/entities/task.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/core/widgets/memento_card.dart';
import 'package:memento/core/widgets/memento_state_views.dart';
import 'package:memento/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: tasksState.when(
        loading: () => const MementoLoadingState(message: 'Loading tasks...'),
        error: (e, _) => MementoErrorState(
          description: 'Could not load your tasks.',
          onRetry: () => ref.read(tasksProvider.notifier).loadTasks(),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return MementoEmptyState(
              title: 'No tasks yet',
              description: 'Capture something you need to get done.',
              icon: Icons.check_circle_outline,
              action: ElevatedButton.icon(
                onPressed: () => context.push('/tasks/create'),
                icon: const Icon(Icons.add),
                label: const Text('New Task'),
              ),
            );
          }
          
          final pendingTasks = tasks.where((t) => t.status != 'completed').toList();
          final completedTasks = tasks.where((t) => t.status == 'completed').toList();

          return CustomScrollView(
            slivers: [
              if (pendingTasks.isNotEmpty) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.s),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Pending',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xs),
                      child: _TaskCard(task: pendingTasks[index]),
                    ),
                    childCount: pendingTasks.length,
                  ),
                ),
              ],
              if (completedTasks.isNotEmpty) ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xl, AppSpacing.l, AppSpacing.s),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Completed',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xs),
                      child: _TaskCard(task: completedTasks[index]),
                    ),
                    childCount: completedTasks.length,
                  ),
                ),
              ],
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/create'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }


}

class _TaskCard extends ConsumerWidget {
  final AppTask task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCompleted = task.status == 'completed';

    return MementoCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.s),
      onTap: () {
        context.push('/tasks/${task.id}');
      },
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            onPressed: () {
              ref.read(tasksProvider.notifier).updateTask(
                task.copyWith(status: isCompleted ? 'pending' : 'completed'),
              );
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? theme.colorScheme.onSurface.withValues(alpha: 0.5) : theme.colorScheme.onSurface,
                  ),
                ),
                if (task.dueDate != null || task.priority != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (task.dueDate != null) ...[
                        Icon(Icons.calendar_today, size: 12, color: theme.colorScheme.error),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d').format(task.dueDate!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                      ],
                      if (task.priority != null && !isCompleted) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.priority!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            onSelected: (value) {
              if (value == 'edit') {
                context.push('/tasks/${task.id}/edit', extra: task);
              } else if (value == 'delete') {
                ref.read(tasksProvider.notifier).deleteTask(task.id);
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
    );
  }
}
