import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bass/file_utils/generated_bindings.dart';

//const String _libName = 'file_utils';

/// The dynamic library in which the symbols for [bass] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    if (kDebugMode) {
      print('Opened dynamic file_utils library on iOS');
    }
//    return DynamicLibrary.open('$_libName.framework/$_libName');
    return DynamicLibrary.executable();
  }
  if (Platform.isAndroid || Platform.isLinux) {
    if (kDebugMode) {
      print('Opened dynamic file_utils library on Android');
    }
    //return DynamicLibrary.open('lib$_libName.so');

    // use this for a static library... this also gives the same error:
    // Failed to load dynamic library
    return DynamicLibrary.executable();
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final file_utils fileUtils = file_utils(_dylib);