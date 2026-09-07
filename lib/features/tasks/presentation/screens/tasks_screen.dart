import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memento/features/tasks/domain/entities/task.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: tasksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      task.status == 'completed' ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: task.status == 'completed' ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      ref.read(tasksProvider.notifier).updateTask(
                        task.copyWith(status: task.status == 'completed' ? 'pending' : 'completed'),
                      );
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(tasksProvider.notifier).deleteTask(task.id);
                    },
                  ),
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
          final newTask = AppTask(
            id: const Uuid().v4(),
            title: 'New Task',
            status: 'pending',
            priority: 'Medium',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: user.uid,
          );
          ref.read(tasksProvider.notifier).addTask(newTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
