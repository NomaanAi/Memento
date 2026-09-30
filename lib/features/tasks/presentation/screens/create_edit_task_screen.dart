import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/features/tasks/domain/entities/task.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/core/theme/app_spacing.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CreateEditTaskScreen extends ConsumerStatefulWidget {
  final AppTask? task;
  final String? taskId;

  const CreateEditTaskScreen({super.key, this.task, this.taskId});

  @override
  ConsumerState<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends ConsumerState<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  
  String _priority = 'Medium';
  DateTime? _dueDate;

  final List<String> _priorities = ['Low', 'Medium', 'High'];

  AppTask? _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentTask == null && widget.taskId != null) {
      final tasks = ref.read(tasksProvider).value;
      if (tasks != null) {
        _currentTask = tasks.where((t) => t.id == widget.taskId).firstOrNull;
      }
    }
    if (_currentTask != null) {
      _titleController = TextEditingController(text: _currentTask!.title);
      _descController = TextEditingController(text: _currentTask!.description ?? '');
      _priority = _currentTask!.priority ?? 'Medium';
      _dueDate = _currentTask!.dueDate;
    } else {
      _titleController = TextEditingController(text: '');
      _descController = TextEditingController(text: '');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider.notifier).currentUser;
    if (user == null) return;

    if (_currentTask == null) {
      // Create
      final newTask = AppTask(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        status: 'pending',
        priority: _priority,
        dueDate: _dueDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: user.uid,
      );
      ref.read(tasksProvider.notifier).addTask(newTask);
    } else {
      // Update
      final updatedTask = _currentTask!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        updatedAt: DateTime.now(),
      );
      ref.read(tasksProvider.notifier).updateTask(updatedTask);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _currentTask != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text('Save'),
          ),
          const SizedBox(width: AppSpacing.s),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'What needs to be done?',
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.l),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Add some details...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('Priority'),
              const SizedBox(height: AppSpacing.s),
              SegmentedButton<String>(
                segments: _priorities.map((p) => ButtonSegment<String>(
                  value: p,
                  label: Text(p),
                )).toList(),
                selected: {_priority},
                onSelectionChanged: (set) {
                  setState(() => _priority = set.first);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('Due Date'),
              const SizedBox(height: AppSpacing.s),
              InkWell(
                onTap: () => _selectDueDate(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: AppSpacing.m),
                      Text(
                        _dueDate != null ? DateFormat.yMMMd().format(_dueDate!) : 'No date set',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      if (_dueDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () => setState(() => _dueDate = null),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
