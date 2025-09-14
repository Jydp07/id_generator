extension FileNameExtension on String {
  /// Returns the file name (with extension) from a file path.
  String get fileName {
    final segments = split(RegExp(r'[\/\\]'));
    return segments.isNotEmpty ? segments.last : this;
  }

  /// Returns the file extension (without dot) from a file path or file name.
  String get fileExtension {
    final name = fileName;
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == name.length - 1) return '';
    return name.substring(dotIndex + 1);
  }
}
