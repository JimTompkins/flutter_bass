import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bass/ffi/generated_bindings.dart';

const String _libName = 'flutter_bass';

/// The dynamic library in which the symbols for [bass] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    if (kDebugMode) {
      print('Opened dynamic BASS library on iOS');
    }
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    if (kDebugMode) {
      print('Opened dynamic BASS library on Android');
    }
    return DynamicLibrary.open('libbass.so');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FlutterBASS bass = FlutterBASS(_dylib);