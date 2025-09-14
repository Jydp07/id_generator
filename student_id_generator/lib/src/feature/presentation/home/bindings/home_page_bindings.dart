import 'package:get/get.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
  }
}
