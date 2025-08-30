// --- main.dart ---
// Local Storage, State Management & Theme
// Entry point: Initializes local DB (Hive), sets up Blocs, manages themes, and starts the app.
// Error handling & clear separation for future maintenance.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'data/task_repository.dart';
import 'bloc/task/task_bloc.dart';
import 'bloc/task/task_event.dart';
import 'bloc/theme/theme_cubit.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- Hive Initialization (Local Storage) ----
  try {
    await Hive.initFlutter();

    // --- Register adapters BEFORE opening boxes ---
    Hive.registerAdapter(TaskAdapter());

    // --- Open necessary persistent boxes for storage ---
    await Hive.openBox<Task>(TaskRepository.tasksBoxName);
    await Hive.openBox(ThemeCubit.settingsBox);
  } catch (e, stack) {
    debugPrint('Hive init failed: $e\n$stack');
  }

  // ---- Dependency Injection: Repository ----
  final repo = TaskRepository();

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final TaskRepository repo;
  const MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // --- ThemeCubit: Manages light/dark mode ---
        BlocProvider(create: (_) => ThemeCubit()),
        // --- TaskBloc: Handles task operations and state ---
        BlocProvider(create: (_) => TaskBloc(repo)..add(const LoadTasks())),
      ],
      // --- Rebuilds MaterialApp on theme change ---
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          title: 'To-Do App',
          debugShowCheckedModeBanner: false,
          themeMode: mode, // --- Switches theme dynamically ---
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF6C5CE7),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF6C5CE7),
            brightness: Brightness.dark,
          ),

          home: const HomePage(),
        ),
      ),
    );
  }
}
