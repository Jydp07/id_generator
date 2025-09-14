import 'package:flutter/material.dart';
import 'package:student_id_generator/src/shared/data/enums/enums.dart';

class IDCardField {
  final String id;
  final String name;
  final FieldType type;
  Offset position;
  Size size;
  bool isSelected;
  String? value;

  IDCardField({
    required this.id,
    required this.name,
    required this.type,
    required this.position,
    required this.size,
    this.isSelected = false,
    this.value,
  });
}
