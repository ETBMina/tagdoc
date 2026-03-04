import 'dart:ffi';
import 'dart:io';
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

abstract class BaseMovieMetadataDataSource {
  String? getMovieMetadataFromFile(String filePath);
}

class MovieMetadataDataSource extends BaseMovieMetadataDataSource {
  late final GetMP4MetadataAsJsonDart _getMP4MetadataAsJson;

  MovieMetadataDataSource({String? customDllPath}) {
    // 3. Load the DLL.
    String dllPath = customDllPath ?? AppConstants.movieDllName;

    // Fallback for test environments where the DLL is not in the execution root
    if (customDllPath == null &&
        Platform.environment.containsKey('FLUTTER_TEST')) {
      dllPath =
          '${Directory.current.path}/windows/dlls/${AppConstants.movieDllName}';
      // Normalize slashes for Windows just in case
      dllPath = dllPath.replaceAll('/', '\\');
    }

    final dylib = DynamicLibrary.open(dllPath);

    // 4. Look up the C function and cast it to the Dart signature.
    _getMP4MetadataAsJson = dylib
        .lookup<NativeFunction<GetMP4MetadataAsJsonC>>(
          AppConstants.getMetadataFunctionName,
        )
        .asFunction<GetMP4MetadataAsJsonDart>();
  }

  /// Reads all metadata from the specified MP4 file and returns it as a JSON string.
  ///
  /// Returns the JSON string on success, or null on failure.
  ///
  /// Returns the JSON string on success, or null on failure.
  @override
  String? getMovieMetadataFromFile(String filePath) {
    final inputPathC = filePath.toNativeUtf8();
    try {
      final resultPtr = _getMP4MetadataAsJson(inputPathC);

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
  }
}
