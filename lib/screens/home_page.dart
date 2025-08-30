// --- home_page.dart ---
// Shows all your to-dos, lets you add/edit/delete with a beautiful UI.
// Features: gradient AppBar, filter chips, search, swipe-to-delete+undo, Bloc state management.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';
import '../bloc/task/task_state.dart';
import '../bloc/theme/theme_cubit.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// --- Enum for filter UI state ---
enum TaskFilter { all, active, completed }

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  TaskFilter _filter = TaskFilter.all;
  String _search = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- Dialogs for Task CRUD ---
  // --- Add Task Dialog ----
  Future<void> _showAddDialog() async {
    _controller.clear();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submitAdd(ctx),
          decoration: const InputDecoration(hintText: 'Write a short task...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
              onPressed: () => _submitAdd(ctx), child: const Text('Add')),
        ],
      ),
    );
  }

  // --- Add Task action ---
  void _submitAdd(BuildContext ctx) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<TaskBloc>().add(AddTask(text));
      Navigator.pop(ctx);
    }
  }

  // --- Edit Task Dialog ---
  Future<void> _showEditDialog(Task task) async {
    _controller.text = task.title;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submitEdit(task, ctx),
          decoration: const InputDecoration(hintText: 'Update the task...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
              onPressed: () => _submitEdit(task, ctx),
              child: const Text('Save')),
        ],
      ),
    );
  }

  // --- Edit Task action ---
  void _submitEdit(Task original, BuildContext ctx) {
    final newText = _controller.text.trim();
    if (newText.isNotEmpty && newText != original.title) {
      final updated = original.copyWith(title: newText);
      context.read<TaskBloc>().add(UpdateTask(updated));
    }
    Navigator.pop(ctx);
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';

    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  // --- Filtering & Searching Tasks ---
  List<Task> _applyFilter(List<Task> tasks) {
    final q = _search.toLowerCase().trim();
    var out = tasks;

    if (_filter == TaskFilter.active) {
      out = out.where((t) => !t.isDone).toList();
    } else if (_filter == TaskFilter.completed) {
      out = out.where((t) => t.isDone).toList();
    }
    if (q.isNotEmpty) {
      out = out.where((t) => t.title.toLowerCase().contains(q)).toList();
    }
    return out;
  }

  // --- Main UI (build) ---
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark;

    return Scaffold(
      // --- Gradient AppBar ---
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade400, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('To-Do App'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
            onPressed: () => context.read<ThemeCubit>().toggle(),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),

      // ------- Body: Search, Filters, List -------
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              // --- Search Bar ---
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _search = '';
                          }),
                        )
                      : null,
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
              const SizedBox(height: 8),

              // --- Filter Chips ---
              Row(
                children: [
                  _buildFilterChip(TaskFilter.all, 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip(TaskFilter.active, 'Active'),
                  const SizedBox(width: 8),
                  _buildFilterChip(TaskFilter.completed, 'Completed'),
                ],
              ),
              const SizedBox(height: 8),

              // --- Task List ---
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final visible = _applyFilter(state.tasks);

                    if (visible.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox,
                                size: 72,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            const SizedBox(height: 12),
                            Text('No tasks found',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            const Text('Tap + to add your first task'),
                          ],
                        ),
                      );
                    }

                    // --- ListView: Dismissible Task Cards ---
                    return ListView.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = visible[index];

                        return Dismissible(
                          key: ValueKey(task.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.delete,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer),
                          ),
                          onDismissed: (_) {
                            // --- Delete Task, Show Undo SnackBar ---
                            context.read<TaskBloc>().add(DeleteTask(task.id));

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Deleted "${task.title}"'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    // --- Restore the deleted task exactly (same id/timestamp) ---
                                    context
                                        .read<TaskBloc>()
                                        .add(UpdateTask(task));
                                  },
                                ),
                              ),
                            );
                          },
                          child: _TaskCard(
                            task: task,
                            onToggle: () => context
                                .read<TaskBloc>()
                                .add(ToggleTask(task.id)),
                            onDelete: () => context
                                .read<TaskBloc>()
                                .add(DeleteTask(task.id)),
                            onEdit: () => _showEditDialog(task),
                            formattedTime: _formatTime(task.createdAt),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // ------- Floating Action (Add) -------
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---- Helper: Filter Chip Builder ----
  Widget _buildFilterChip(TaskFilter filterType, String label) {
    final selected = _filter == filterType;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (v) => setState(() => _filter = filterType),
    );
  }
}

// --- _TaskCard: Single Task UI Component ---

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final String formattedTime;

  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onLongPress: onEdit, // --- Long press = quick edit ---
        leading: GestureDetector(
          // --- Checkbox with animation ---
          onTap: onToggle,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: task.isDone
                ? Container(
                    key: const ValueKey('done'),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary),
                    child:
                        const Icon(Icons.check, size: 20, color: Colors.white),
                  )
                : Container(
                    key: const ValueKey('pending'),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1.5,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.2))),
                    child: const Icon(Icons.circle_outlined, size: 20),
                  ),
          ),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            task.title,
            key: ValueKey(task.title + task.isDone.toString()),
            style: TextStyle(
              decoration: task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        subtitle: Text(formattedTime),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
