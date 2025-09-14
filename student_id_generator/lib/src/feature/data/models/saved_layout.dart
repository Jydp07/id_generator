import 'package:flutter/material.dart';

/// Model representing a saved layout configuration
class SavedLayout {
  final String id;
  final String name;
  final String? description;
  final String? templatePath;
  final String? excelPath;
  final List<String> excelHeaders;
  final List<FieldPosition> fieldPositions;
  final DateTime createdAt;
  final DateTime lastModified;

  const SavedLayout({
    required this.id,
    required this.name,
    this.description,
    this.templatePath,
    this.excelPath,
    this.excelHeaders = const [],
    this.fieldPositions = const [],
    required this.createdAt,
    required this.lastModified,
  });

  /// Create a copy of this layout with updated values
  SavedLayout copyWith({
    String? id,
    String? name,
    String? description,
    String? templatePath,
    String? excelPath,
    List<String>? excelHeaders,
    List<FieldPosition>? fieldPositions,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return SavedLayout(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      templatePath: templatePath ?? this.templatePath,
      excelPath: excelPath ?? this.excelPath,
      excelHeaders: excelHeaders ?? this.excelHeaders,
      fieldPositions: fieldPositions ?? this.fieldPositions,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'templatePath': templatePath,
      'excelPath': excelPath,
      'excelHeaders': excelHeaders,
      'fieldPositions': fieldPositions.map((fp) => fp.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  /// Create from JSON
  factory SavedLayout.fromJson(Map<String, dynamic> json) {
    return SavedLayout(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      templatePath: json['templatePath'] as String?,
      excelPath: json['excelPath'] as String?,
      excelHeaders: (json['excelHeaders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      fieldPositions: (json['fieldPositions'] as List<dynamic>?)
              ?.map((e) => FieldPosition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedLayout &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.templatePath == templatePath &&
        other.excelPath == excelPath &&
        _listEquals(other.excelHeaders, excelHeaders) &&
        _listEquals(other.fieldPositions, fieldPositions);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      templatePath,
      excelPath,
      excelHeaders,
      fieldPositions,
    );
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

/// Model representing the position and properties of a field
class FieldPosition {
  final String id;
  final String name;
  final String fieldType;
  final double x;
  final double y;
  final double width;
  final double height;
  final String? excelHeader;
  final TextStyle? textStyle;

  const FieldPosition({
    required this.id,
    required this.name,
    required this.fieldType,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.excelHeader,
    this.textStyle,
  });

  /// Create a copy with updated values
  FieldPosition copyWith({
    String? id,
    String? name,
    String? fieldType,
    double? x,
    double? y,
    double? width,
    double? height,
    String? excelHeader,
    TextStyle? textStyle,
  }) {
    return FieldPosition(
      id: id ?? this.id,
      name: name ?? this.name,
      fieldType: fieldType ?? this.fieldType,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      excelHeader: excelHeader ?? this.excelHeader,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fieldType': fieldType,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'excelHeader': excelHeader,
      'textStyle': textStyle != null ? _textStyleToJson(textStyle!) : null,
    };
  }

  /// Create from JSON
  factory FieldPosition.fromJson(Map<String, dynamic> json) {
    return FieldPosition(
      id: json['id'] as String,
      name: json['name'] as String,
      fieldType: json['fieldType'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      excelHeader: json['excelHeader'] as String?,
      textStyle: json['textStyle'] != null
          ? _textStyleFromJson(json['textStyle'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert TextStyle to JSON
  static Map<String, dynamic> _textStyleToJson(TextStyle style) {
    return {
      'fontSize': style.fontSize,
      'fontWeight': style.fontWeight?.index,
      'fontStyle': style.fontStyle?.index,
      'color': style.color?.value,
      'decoration': style.decoration != null
          ? _getDecorationIndex(style.decoration!)
          : null,
    };
  }

  /// Get decoration index for serialization
  static int _getDecorationIndex(TextDecoration decoration) {
    if (decoration == TextDecoration.underline) return 0;
    if (decoration == TextDecoration.overline) return 1;
    if (decoration == TextDecoration.lineThrough) return 2;
    return 0;
  }

  /// Get decoration from index for deserialization
  static TextDecoration _getDecorationFromIndex(int index) {
    switch (index) {
      case 0:
        return TextDecoration.underline;
      case 1:
        return TextDecoration.overline;
      case 2:
        return TextDecoration.lineThrough;
      default:
        return TextDecoration.underline;
    }
  }

  /// Create TextStyle from JSON
  static TextStyle _textStyleFromJson(Map<String, dynamic> json) {
    return TextStyle(
      fontSize: json['fontSize'] as double?,
      fontWeight: json['fontWeight'] != null
          ? FontWeight.values[json['fontWeight'] as int]
          : null,
      fontStyle: json['fontStyle'] != null
          ? FontStyle.values[json['fontStyle'] as int]
          : null,
      color: json['color'] != null ? Color(json['color'] as int) : null,
      decoration: json['decoration'] != null
          ? _getDecorationFromIndex(json['decoration'] as int)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FieldPosition &&
        other.id == id &&
        other.name == name &&
        other.fieldType == fieldType &&
        other.x == x &&
        other.y == y &&
        other.width == width &&
        other.height == height &&
        other.excelHeader == excelHeader;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      fieldType,
      x,
      y,
      width,
      height,
      excelHeader,
    );
  }
}
