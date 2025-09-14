import 'dart:io';
import 'dart:typed_data';

class PickedLocalFile {
  PickedLocalFile({required this.file, required this.name, this.bytes});

  File? file;
  String name;
  Uint8List? bytes;

  // Get bytes for web compatibility
  Future<Uint8List> getBytes() async {
    if (bytes != null) return bytes!;
    if (file != null) return await file!.readAsBytes();
    throw Exception('No file data available');
  }
}
