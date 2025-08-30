import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

/// --- task_repository.dart ---
/// Repository for managing all Task CRUD operations using Hive local storage.
/// - Centralizes all Hive logic for easy refactor/testing.
/// - Ensures box is opened for safe local reads & writes.
class TaskRepository {
  static const String tasksBoxName = 'tasks';

  /// Create a TaskRepository. Checks that the Hive box is open,
  /// Throws [Exception] if box isn't open (see main.dart for box opening).
  TaskRepository() {
    if (!Hive.isBoxOpen(tasksBoxName)) {
      throw Exception(
          'Tasks box is not open. Open it in main() before using repository.');
    }
  }

  /// Internal getter for the box. Keeps Hive logic encapsulated.
  Box<Task> get _box => Hive.box<Task>(tasksBoxName);

  /// Get all tasks—sorted so incomplete appear first, followed by newest tasks first for quick review.
  List<Task> getAll() {
    final tasks = _box.values.toList();
    tasks.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return tasks;
  }

  /// Add OR update a Task by its id (using Hive put).
  /// Returns a Future for async UI updating/awaiting.
  Future<void> upsert(Task task) async {
    try {
      await _box.put(task.id, task);
    } catch (e) {
      debugPrint('Error saving task: $e');
      rethrow;
    }
  }

  /// Delete a task by id.
  Future<void> delete(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      // Handle deletion failures if needed
      rethrow;
    }
  }

  /// Returns true if task with given id exists in Hive box.
  bool exists(String id) => _box.containsKey(id);

  /// Gets a task by id. Returns Task or null.
  Task? getById(String id) => _box.get(id);
}
