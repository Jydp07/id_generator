import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/router/app_routes.dart';
import 'package:student_id_generator/src/feature/presentation/home/bindings/home_page_bindings.dart';
import 'package:student_id_generator/src/feature/presentation/home/pages/home_page.dart';

///All the routing for the app
class AppRouting {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      curve: Curves.bounceIn,
      binding: HomePageBindings(),
    ),
  ];
}
