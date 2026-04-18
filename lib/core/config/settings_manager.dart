import 'dart:convert';
import 'dart:io';

class TagInfo {
  final String displayName;
  final List<String> searchKeys;

  TagInfo({required this.displayName, required this.searchKeys});

  factory TagInfo.fromJson(Map<String, dynamic> json) {
    return TagInfo(
      displayName: json['displayName'] ?? '',
      searchKeys: List<String>.from(json['searchKeys'] ?? []),
    );
  }
}

class SettingsManager {
  static String defaultQuality = 'WEB-DL';
  static List<TagInfo> sources = [];
  static List<TagInfo> qualities = [];
  static List<String> resolutions = ['2160p (4K)', '1080p', '720p', 'SD'];

  static String renameFormat =
      '{title} ({year}) [{resolution}] [{quality}] [{source}]';

  /// Loads configuration statically from a JSON string or file.
  static void loadSettingsFromFile(String filePath) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return;

      final content = file.readAsStringSync();
      final data = jsonDecode(content);

      if (data['defaultQuality'] != null) {
        defaultQuality = data['defaultQuality'];
      }

      if (data['sources'] != null) {
        sources = (data['sources'] as List)
            .map((item) => TagInfo.fromJson(item))
            .toList();
      }

      if (data['quality'] != null) {
        qualities = (data['quality'] as List)
            .map((item) => TagInfo.fromJson(item))
            .toList();
      }

      if (data['resolutions'] != null) {
        resolutions = List<String>.from(data['resolutions']);
      }

      if (data['renameFormat'] != null) {
        renameFormat = data['renameFormat'];
      }
    } catch (e) {
      // Handle the error silently or log it in production
      print('Warning: Failed to load settings.json: $e');
    }
  }

  /// Predicts the quality (displayName) dynamically from the loaded settings.
  static String predictQuality(String filename) {
    final lower = filename.toLowerCase();

    for (var quality in qualities) {
      for (var key in quality.searchKeys) {
        if (lower.contains(key.toLowerCase())) {
          return quality.displayName;
        }
      }
    }
    return defaultQuality;
  }

  /// Predicts the source (displayName) dynamically from the loaded settings.
  static String? predictSource(String filename) {
    final lower = filename.toLowerCase();

    for (var source in sources) {
      for (var key in source.searchKeys) {
        if (lower.contains(key.toLowerCase())) {
          return source.displayName;
        }
      }
    }
    return null; // Keep null if unset
  }
}
