import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/task.dart';
import '../../data/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

/// --- task_bloc.dart ---
/// TaskBloc manages all to-do business logic, responding to events to load, add, update, toggle,
/// and delete tasks using the repository, and keeps UI in sync via TaskState.
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repo;

  TaskBloc(this.repo) : super(TaskState.initial()) {
    on<LoadTasks>(_onLoad);
    on<AddTask>(_onAdd);
    on<UpdateTask>(_onUpdate);
    on<ToggleTask>(_onToggle);
    on<DeleteTask>(_onDelete);
  }

  // Load tasks from repository and emit them.
  void _onLoad(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final tasks = repo.getAll();
      emit(state.copyWith(loading: false, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // Add new task with generated id
  void _onAdd(AddTask event, Emitter<TaskState> emit) async {
    final title = event.title.trim();
    if (title.isEmpty) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final task = Task(id: id, title: title, createdAt: DateTime.now());
    await repo.upsert(task);
    add(const LoadTasks());
  }

  // Update existing task (edit or restore)
  void _onUpdate(UpdateTask event, Emitter<TaskState> emit) async {
    await repo.upsert(event.task);
    add(const LoadTasks());
  }

  // Toggle completed state
  void _onToggle(ToggleTask event, Emitter<TaskState> emit) async {
    final existing = repo.getById(event.id);
    if (existing == null) return;
    final toggled = existing.copyWith(isDone: !existing.isDone);
    await repo.upsert(toggled);
    add(const LoadTasks());
  }

  // Delete
  void _onDelete(DeleteTask event, Emitter<TaskState> emit) async {
    final task = repo.getById(event.id);
    await repo.delete(event.id);
    add(const LoadTasks());
  }
}
