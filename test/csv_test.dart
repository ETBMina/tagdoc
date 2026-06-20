import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized for path_provider/url_launcher
  WidgetsFlutterBinding.ensureInitialized();

  print("Testing CSV Export...");
  await createAndOpenCsvV8();
}

Future<void> createAndOpenCsvV8() async {
  List<List<dynamic>> rows = [
    ["Product", "Price", "Date"],
    ["Widget A", 49.99, DateTime.now().toString()],
    ["Widget B", 80.00, DateTime.now().toString()],
  ];

  // In v8 of the csv package, CsvCodec was renamed to Csv.
  // The recommended approach is to use the global 'csv' instance's encode method.
  String csvData = csv.encode(rows);

  try {
    // Attempt to get temp directory from plugin, fallback to system temp
    Directory tempDir;
    try {
      tempDir = await getTemporaryDirectory();
    } catch (e) {
      debugPrint("Using system temp fallback due to: $e");
      tempDir = Directory.systemTemp;
    }

    final String filePath = '${tempDir.path}\\app_temp_export.csv';
    final File file = File(filePath);

    // Write the data (overwrites existing)
    await file.writeAsString('\uFEFF$csvData');

    // Open the file
    final Uri fileUri = Uri.file(filePath);

    // Attempt to launch via url_launcher, if it fails or isn't implemented, fallback to Process.run
    bool launched = false;
    try {
      if (await canLaunchUrl(fileUri)) {
        await launchUrl(fileUri);
        launched = true;
      }
    } catch (e) {
      debugPrint("url_launcher not available: $e");
    }

    if (!launched) {
      await Process.run('start', ['', filePath], runInShell: true);
    }
  } on FileSystemException catch (e) {
    if (e.osError?.errorCode == 32) {
      print("CRITICAL: File is locked! Close the CSV in Excel and try again.");
    } else {
      print("FileSystem Error: $e");
    }
  } catch (e) {
    print("General Error: $e");
  }
}
