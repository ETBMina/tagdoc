import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:tagdoc/core/constants/app_constants.dart';

// 1. Define the C function signature. This must match the C++ header file's
//    exported C-compatible function.
//
// C/C++: const char* GetMP4MetadataAsJson(const char* inputFilePath)
// Dart:  Pointer<Utf8> Function(Pointer<Utf8> inputFilePath)
//
// The returned `const char*` is a pointer to a C-style string. The `const`
// indicates that the string's content should not be modified.
// For FFI, this string is typically allocated on the heap by the C++ function
// (e.g., using `strdup` or `malloc`), and the Dart side is responsible for
// freeing this memory to prevent leaks.
typedef GetMP4MetadataAsJsonC =
    Pointer<Utf8> Function(Pointer<Utf8> inputFilePath);

// 2. Define the Dart function signature.
typedef GetMP4MetadataAsJsonDart =
    Pointer<Utf8> Function(Pointer<Utf8> inputFilePath);

/// Contract for acquiring movie metadata from local video files.
abstract class BaseMovieMetadataDataSource {
  /// Reads metadata from the given [filePath] asynchronously.
  Future<String?> getMovieMetadataFromFile(String filePath);
}

/// Data source implementation that extracts MP4 metadata via C++ FFI.
class MovieMetadataDataSource extends BaseMovieMetadataDataSource {
  final String _dllPath;

  /// Initializes the data source with an optional [customDllPath].
  MovieMetadataDataSource({String? customDllPath})
    : _dllPath = _resolveDllPath(customDllPath);

  /// Resolves the absolute path to the native DLL.
  static String _resolveDllPath(String? customDllPath) {
    String dllPath = customDllPath ?? AppConstants.movieDllName;

    // Fallback for test environments where the DLL is not in the execution root
    if (customDllPath == null &&
        Platform.environment.containsKey('FLUTTER_TEST')) {
      dllPath =
          '${Directory.current.path}/windows/dlls/${AppConstants.movieDllName}';
      // Normalize slashes for Windows just in case
      dllPath = dllPath.replaceAll('/', '\\');
    }
    return dllPath;
  }

  /// Reads all metadata from the specified MP4 file and returns it as a JSON string.
  ///
  /// Offloads the FFI DLL invocation to a background worker isolate via [Isolate.run]
  /// to ensure the Flutter UI thread remains responsive (60+ FPS) when processing
  /// multiple large files.
  ///
  /// Returns the JSON string on success, or `null` on failure.
  @override
  Future<String?> getMovieMetadataFromFile(String filePath) async {
    final dllPath = _dllPath;

    // Execute in a background isolate so the main thread's event loop continues
    // pumping UI frames and progress bar animations.
    return await Isolate.run(() {
      final dylib = DynamicLibrary.open(dllPath);

      final getMP4MetadataAsJson = dylib
          .lookup<NativeFunction<GetMP4MetadataAsJsonC>>(
            AppConstants.getMetadataFunctionName,
          )
          .asFunction<GetMP4MetadataAsJsonDart>();

      final inputPathC = filePath.toNativeUtf8();
      try {
        final resultPtr = getMP4MetadataAsJson(inputPathC);

        if (resultPtr.address == 0) {
          return null; // The C function returned a NULL pointer.
        }

        final jsonString = resultPtr.toDartString();
        // NOTE: We do NOT free resultPtr here because it points to C++ thread_local static memory.
        return jsonString;
      } finally {
        malloc.free(
          inputPathC,
        ); // Always free the input string memory allocated by Dart.
      }
    });
  }
}
