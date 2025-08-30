import 'package:equatable/equatable.dart';
import '../../models/task.dart';

/// --- task_event.dart ---
/// Base class for all Task-related Bloc events.
/// Using [Equatable] for value comparisons makes Bloc more efficient.
abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

/// Requests all tasks from storage, typically at app start or after changes.
class LoadTasks extends TaskEvent {
  const LoadTasks();
}

/// Adds a new task, requiring only a [title].
class AddTask extends TaskEvent {
  final String title;
  const AddTask(this.title);

  @override
  List<Object?> get props => [title];
}

/// Updates an existing task (for editing or restoring).
/// [task]: fully replaces the old one with new values.
class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Toggles the completion state for the task with given [id].
/// Used when user checks/unchecks a task in UI.
class ToggleTask extends TaskEvent {
  final String id;
  const ToggleTask(this.id);

  @override
  List<Object?> get props => [id];
}

/// Deletes a task by its [id].
/// Used on swipe-to-delete or trash icon actions.
class DeleteTask extends TaskEvent {
  final String id;
  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}
