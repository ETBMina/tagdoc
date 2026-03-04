import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class LocalFileDataSource {
  Future<List<String>> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
      allowMultiple: true,
    );

    if (result != null) {
      return result.files.map((file) => file.path!).toList();
    }
    return [];
  }

  Future<List<String>> selectFiles() async {
    return _pickFiles();
  }

  Future<String> renameFile(String oldFilePath, String newFileName) async {
    final file = File(oldFilePath);
    final directory = p.dirname(oldFilePath);
    final newPath = p.join(directory, newFileName);
    final renamedFile = await file.rename(newPath);
    return renamedFile.path;
  }
}
