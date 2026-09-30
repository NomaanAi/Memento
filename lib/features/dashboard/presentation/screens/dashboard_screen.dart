import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:memento/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:memento/features/projects/presentation/providers/project_provider.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';
import 'package:memento/features/tasks/domain/entities/task.dart';
import 'package:memento/features/projects/domain/entities/project.dart';
import 'package:memento/features/notes/domain/entities/note.dart';
import 'package:memento/core/widgets/memento_card.dart';
import 'package:memento/core/widgets/memento_state_views.dart';
import 'package:memento/core/theme/app_spacing.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider.notifier).currentUser;
    final projectsState = ref.watch(projectsProvider);
    final tasksState = ref.watch(tasksProvider);
    final notesState = ref.watch(notesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user?.displayName, theme),
              const SizedBox(height: AppSpacing.xl),
              _buildQuickCapture(context, theme),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionHeader(
                context,
                'Priority Focus',
                () => context.push('/tasks'),
              ),
              const SizedBox(height: AppSpacing.m),
              _buildTasksSection(tasksState, context, ref),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionHeader(
                context,
                'Active Projects',
                () => context.push('/projects'),
              ),
              const SizedBox(height: AppSpacing.m),
              _buildProjectsSection(projectsState, context, ref),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionHeader(
                context,
                'Recent Knowledge',
                () => context.push('/notes'),
              ),
              const SizedBox(height: AppSpacing.m),
              _buildNotesSection(notesState, context, ref),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? name, ThemeData theme) {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d');
    final formattedDate = formatter.format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Good morning, ${name ?? 'User'}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => context.push('/profile'),
          borderRadius: BorderRadius.circular(24),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            radius: 24,
            child: Icon(
              Icons.person_outline_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickCapture(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _QuickCaptureButton(
            icon: Icons.check_circle_outline,
            label: 'Task',
            color: theme.colorScheme.primary,
            onTap: () => context.push('/tasks'),
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: _QuickCaptureButton(
            icon: Icons.lightbulb_outline,
            label: 'Note',
            color: theme.colorScheme.secondary,
            onTap: () => context.push('/notes'),
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: _QuickCaptureButton(
            icon: Icons.folder_outlined,
            label: 'Project',
            color: const Color(0xFFF59E0B), // Warning color as tertiary
            onTap: () => context.push('/projects'),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: Text(
            'See All',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksSection(
    AsyncValue<List<AppTask>> tasksState,
    BuildContext context,
    WidgetRef ref,
  ) {
    return tasksState.when(
      loading: () => const MementoLoadingState(),
      error: (e, _) => MementoErrorState(
        description: 'Failed to load tasks.',
        onRetry: () => ref.read(tasksProvider.notifier).loadTasks(),
      ),
      data: (tasks) {
        final pendingTasks = tasks.where((t) => t.status != 'completed').toList();
        if (pendingTasks.isEmpty) {
          return const MementoEmptyState(
            title: 'No pending tasks',
            description: 'You\'re all caught up!',
            icon: Icons.check_circle_outline,
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pendingTasks.length > 3 ? 3 : pendingTasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) {
            final task = pendingTasks[index];
            return MementoCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.m,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Theme.of(context).colorScheme.onSurface.withValues(
                      alpha: 0.4,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (task.dueDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d').format(task.dueDate!),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProjectsSection(
    AsyncValue<List<Project>> projectsState,
    BuildContext context,
    WidgetRef ref,
  ) {
    return projectsState.when(
      loading: () => const MementoLoadingState(),
      error: (e, _) => MementoErrorState(
        description: 'Failed to load projects.',
        onRetry: () => ref.read(projectsProvider.notifier).loadProjects(),
      ),
      data: (projects) {
        if (projects.isEmpty) {
          return const MementoEmptyState(
            title: 'No active projects',
            description: 'Create your first workspace.',
            icon: Icons.folder_open_outlined,
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length > 3 ? 3 : projects.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) {
            final project = projects[index];
            return MementoCard(
              withAccent: true,
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (project.description != null &&
                            project.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            project.description!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotesSection(
    AsyncValue<List<Note>> notesState,
    BuildContext context,
    WidgetRef ref,
  ) {
    return notesState.when(
      loading: () => const MementoLoadingState(),
      error: (e, _) => MementoErrorState(
        description: 'Failed to load notes.',
        onRetry: () => ref.read(notesProvider.notifier).loadNotes(),
      ),
      data: (notes) {
        if (notes.isEmpty) {
          return const MementoEmptyState(
            title: 'Your second brain starts here',
            description: 'Capture your first idea.',
            icon: Icons.lightbulb_outline,
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.m,
            mainAxisSpacing: AppSpacing.m,
            childAspectRatio: 1.2,
          ),
          itemCount: notes.length > 4 ? 4 : notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return MementoCard(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          note.title,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Expanded(
                    child: Text(
                      note.content,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickCaptureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickCaptureButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MementoCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
