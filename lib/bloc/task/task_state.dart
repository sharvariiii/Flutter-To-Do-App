import 'package:equatable/equatable.dart';
import '../../models/task.dart';

/// --- task_state.dart ---
/// Represents the current state of all tasks in the Bloc.
/// Keeps track of loading status, the task list, and any error messages.
class TaskState extends Equatable {
  final bool loading;

  final List<Task> tasks;

  final String? error;

  const TaskState({
    required this.loading,
    required this.tasks,
    this.error,
  });

  /// Creates the initial, empty state (loading is false, no tasks/error).
  factory TaskState.initial() => const TaskState(loading: false, tasks: []);

  /// Produces a copy of this state with optional new values.
  /// Uses default field values (current state) when not specified, making updates easy and safe in Bloc.
  TaskState copyWith({
    bool? loading,
    List<Task>? tasks,
    String? error,
  }) {
    return TaskState(
      loading: loading ?? this.loading,
      tasks: tasks ?? this.tasks,
      error: error, // null value wipes out error (intended)
    );
  }

  /// Allows value-based equality, required for efficient Bloc state handling.
  @override
  List<Object?> get props => [loading, tasks, error];
}
