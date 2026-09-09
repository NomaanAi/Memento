import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memento/features/projects/presentation/providers/project_provider.dart';
import 'package:memento/features/tasks/presentation/providers/task_provider.dart';
import 'package:memento/features/notes/presentation/providers/note_provider.dart';
import 'package:memento/core/widgets/memento_card.dart';
import 'package:memento/core/widgets/memento_state_views.dart';
import 'package:memento/core/theme/app_spacing.dart';

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
    final theme = Theme.of(context);
    final projects = ref.watch(projectsProvider).value ?? [];
    final tasks = ref.watch(tasksProvider).value ?? [];
    final notes = ref.watch(notesProvider).value ?? [];

    final q = _query.toLowerCase();
    final filteredProjects = q.isEmpty
        ? []
        : projects
              .where(
                (p) =>
                    p.name.toLowerCase().contains(q) ||
                    (p.description?.toLowerCase().contains(q) ?? false),
              )
              .toList();
    final filteredTasks = q.isEmpty
        ? []
        : tasks
              .where(
                (t) =>
                    t.title.toLowerCase().contains(q) ||
                    (t.description?.toLowerCase().contains(q) ?? false),
              )
              .toList();
    final filteredNotes = q.isEmpty
        ? []
        : notes
              .where(
                (n) =>
                    n.title.toLowerCase().contains(q) ||
                    n.content.toLowerCase().contains(q),
              )
              .toList();

    final hasResults = filteredProjects.isNotEmpty || filteredTasks.isNotEmpty || filteredNotes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppRadii.m),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search workspaces, tasks, notes...',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _query = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
            ),
            onChanged: (val) {
              setState(() {
                _query = val;
              });
            },
          ),
        ),
      ),
      body: _query.isEmpty
          ? const MementoEmptyState(
              title: 'What are you looking for?',
              description: 'Search across all your workspaces, tasks, and knowledge base.',
              icon: Icons.search_rounded,
            )
          : !hasResults
          ? const MementoEmptyState(
              title: 'No results found',
              description: 'Try adjusting your search query.',
              icon: Icons.search_off_rounded,
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                if (filteredProjects.isNotEmpty) ...[
                  Text(
                    'Workspaces',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  ...filteredProjects.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s),
                      child: MementoCard(
                        onTap: () => context.push('/projects'),
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Row(
                          children: [
                            Icon(Icons.folder_outlined, color: theme.colorScheme.primary),
                            const SizedBox(width: AppSpacing.m),
                            Expanded(child: Text(p.name, style: theme.textTheme.titleMedium)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],
                if (filteredTasks.isNotEmpty) ...[
                  Text(
                    'Tasks',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  ...filteredTasks.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s),
                      child: MementoCard(
                        onTap: () => context.push('/tasks'),
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Row(
                          children: [
                            Icon(
                              t.status == 'completed' ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: t.status == 'completed' ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                            const SizedBox(width: AppSpacing.m),
                            Expanded(
                              child: Text(
                                t.title,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  decoration: t.status == 'completed' ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],
                if (filteredNotes.isNotEmpty) ...[
                  Text(
                    'Knowledge Base',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  ...filteredNotes.map(
                    (n) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s),
                      child: MementoCard(
                        onTap: () => context.push('/notes'),
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.description_outlined, color: theme.colorScheme.secondary),
                            const SizedBox(width: AppSpacing.m),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.title, style: theme.textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    n.content,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
