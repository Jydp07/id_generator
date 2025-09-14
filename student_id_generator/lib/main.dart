import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';
import 'package:student_id_generator/src/core/router/app_routes.dart';
import 'package:student_id_generator/src/core/router/app_routing.dart';
import 'package:student_id_generator/src/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.home,
      getPages: AppRouting.routes,
    );
  }
}
