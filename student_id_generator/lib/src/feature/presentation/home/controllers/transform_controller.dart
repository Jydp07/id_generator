import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_id_generator/src/core/theme/app_colors.dart';
import 'package:student_id_generator/src/feature/presentation/home/controllers/home_page_controller.dart';

class TransformController extends HomePageController {
  final Offset initialPosition;
  final Size initialSize;

  final colors = [
    AppColors.black,
    AppColors.red,
    AppColors.blue,
    AppColors.green,
    AppColors.orange,
    AppColors.purple,
    AppColors.white
  ];
  late final Rx<Rect?> _rect = Rx<Rect?>(null);

  final Rx<TextStyle> _style = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  ).obs;

  TransformController({
    required this.initialPosition,
    required this.initialSize,
  });

  Rect? get rect => _rect.value;

  void setRect(Rect? rect) {
    _rect.value = rect!;
    update();
  }

  TextStyle get style => _style.value;
  void setStyle(TextStyle style) => _style.value = style;

  double get fontSize => _style.value.fontSize ?? 12.0;
  void setFontSize(double size) {
    _style.value = _style.value.copyWith(fontSize: size);
  }

  bool get isBold => _style.value.fontWeight == FontWeight.bold;
  void setBold(bool bold) {
    _style.value = _style.value.copyWith(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  bool get isItalic => _style.value.fontStyle == FontStyle.italic;
  void setItalic(bool italic) {
    _style.value = _style.value.copyWith(
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );
  }

  bool get isUnderline => _style.value.decoration == TextDecoration.underline;
  void setUnderline(bool underline) {
    _style.value = _style.value.copyWith(
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: AppColors.black,
    );
  }

  Color get color => _style.value.color ?? AppColors.black;
  void setColor(Color color){
    _style.value = _style.value.copyWith(
      color: color
    );
  }

  @override
  void onInit() {
    setRect(
      Rect.fromLTWH(
        initialPosition.dx,
        initialPosition.dy,
        initialSize.width,
        initialSize.height,
      ),
    );
    super.onInit();
  }
}
