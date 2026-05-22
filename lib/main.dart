import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'adapters/priority_adapter.dart';
import 'adapters/task_category_adapter.dart';
import 'adapters/task_adapter.dart';
import 'controllers/task_controller.dart';
import 'models/task.dart';
import 'views/home_view.dart';
import 'theme/app_colors.dart';

/// Binds TaskController lazily when the app first loads.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(TaskCategoryAdapter());
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasks');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.accent,
          surface: AppColors.bg,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        fontFamily: 'SF Pro Text',
        dividerColor: AppColors.border,
      ),
      home: const HomeView(),
    );
  }
}
