import 'package:hive/hive.dart';

/// --- task.dart ---
/// Represents a single to-do task in the app.
/// Each task is stored locally in Hive for persistence.
/// This manual TypeAdapter avoids any need for build_runner/codegen.

class Task {
  /// Unique identifier for the task (use timestamp, uuid, etc.)
  final String id;

  /// Title or main text of the task.
  final String title;

  /// Whether the task is completed.
  final bool isDone;

  /// Date and time when the task was created.
  final DateTime createdAt;

  /// Creates an immutable Task. All fields required except [isDone].
  const Task({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });

  /// Returns a copy of this Task, replacing specified fields.
  ///
  /// Use for immutable updates:
  /// ```
  /// var newTask = oldTask.copyWith(title: "Updated title");
  /// ```
  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Hive TypeAdapter for [Task] objects.
///
/// - Always use a unique [typeId] per model
/// - Read/write fields in the same order for reliability
/// - Register the adapter before opening the box!
///   ```
///   Hive.registerAdapter(TaskAdapter());
///   ```
class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    // Always read in the same order as written
    final id = reader.readString();
    final title = reader.readString();
    final isDone = reader.readBool();
    final createdMillis = reader.readInt();
    return Task(
      id: id,
      title: title,
      isDone: isDone,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMillis),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    // Write fields in stable order (matches read)
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeBool(obj.isDone);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
