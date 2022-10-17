import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bass/flutter_bass.dart';
import 'package:flutter_bass/fileUtils.dart';
import 'package:flutter_bass/file_utils/generated_bindings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> get _localPath async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/assets/sounds/cowbell.mp3');
  }

  Future<String> get _localFileName async {
    final path = await _localPath;
    String fileName = '$path/assets/sounds/cowbell.mp3';
    return fileName;
  }

  // read an mp3 file from assets and save to a temporary file
  Future<String> getMp3FileFromAssets(String name) async {
    // load from the bundle
    final byteData = await rootBundle.load('assets/sounds/$name.mp3');
    final buffer = byteData.buffer;

    // build a temporary file name
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/' + name + '.mp3';

    // write the data to the temporary file
    Future<File> tempFile = File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    // return the path to the temp file
    return filePath;
  }

  @override
  void initState() {
    super.initState();
  }

  int version = 0;
  int errorCode = 0;
  //int cowbellSample = 0;
  int cowbellStream = 0;
  //int cowbellChannel = 0;

  @override
  Widget build(BuildContext context) {
    //const textStyle = TextStyle(fontSize: 25);
    //const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter BASS Example'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextButton(
                    child: Text(
                      'Init BASS',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      if (kDebugMode) {
                        if (bass == null) {
                          print('Error: bass is null!');
                        } else {
                          print('bass is not null');
                        }
                        if (bass.BASS_Init == null) {
                          print('Error: bass.BASS_Init is null!');
                        }
                      }
                      // BASS_Init: -1 = default device, 44100 = sample rate, 0 = flags
                      bass.BASS_Init(-1, 44100, 0, ffi.nullptr, ffi.nullptr);
                      errorCode = bass.BASS_ErrorGetCode();
                      print('Error code = $errorCode');
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextButton(
                    child: Text(
                      'Get BASS version',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      version = bass.BASS_GetVersion();
                      var versionString = version.toRadixString(16);
                      print('BASS version: $versionString');
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextButton(
                    child: Text(
                      'Load sample',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () async {
                      String _fileName = await _localFileName;

                      //File mp3File = new File(_fileName);
                      //Uint8List _mp3 = new Uint8List(0);
                      //await mp3File.readAsBytes().then((value) {
                      //  _mp3 = Uint8List.fromList(value);
                      //});
                      //final ByteData bytes = await rootBundle.load('assets/sounds/cowbell.mp3');
                      //final mp3 = bytes.buffer.asUint8List();
                      //int _length = mp3.length;
                      //Uint8List _mp3 = (await rootBundle.load(_fileName)).buffer.asUint8List();
                      //File _file = File(_localFileName);
                      //var _list = await _file.readAsBytes();
                      //int _length = _list.length;
                      //Pointer<Uint8> _buf = allocate<Uint8>(count: _length);
                      //print('File size = $_length');
                      //ffi.Pointer<ffi.Void> mp3Buff = allocate<int>(count: _length);
                      //mp3Buff.setAll(mp3);
                      //ffi.Pointer<ffi.Uint8List> _mp3Pointer = ffi.Pointer<ffi.Void>.from(mp3);

                      //
                      // Approach #1: use the standard fopen function.
                      // This fails as it returns a null pointer.
                      /*
                      String fileName = await _localFileName;
                      print('Loading file: $fileName');
                      final ffi.Pointer<FILE> mp3File = await fileUtils.fopen(
                          fileName.toNativeUtf8().cast<ffi.Char>(),
                          "r".toNativeUtf8().cast<ffi.Char>());
                      print('File opened: $mp3File');
                      final ffi.Pointer<ffi.Void> mp3File2 = mp3File.cast();
                      print('Pointer cast complete: $mp3File2');
                      cowbellSample = bass.BASS_SampleLoad(
                          0, // mem: use file instead of memory
                          mp3File2, // *file: file pointer
                          0, // offset: use file from the start
                          0, // length: use entire file
                          16, // max: maximum number of simultaneous playbacks
                          0 // flags: no flags set
                          );
                      print('SampleLoad complete: $cowbellSample');
                      */

                      //
                      // Approach #1a: use a custom fileOpen C function.
                      // This fails as it returns a null pointer.
                      /*
                      String fileName = await _localFileName;
                      print('Loading file: $fileName');
                      final ffi.Pointer<FILE> mp3File = await fileUtils.openFile(
                          fileName.toNativeUtf8().cast<ffi.Char>());
                      print('File opened: $mp3File');
                      final ffi.Pointer<ffi.Void> mp3File2 = mp3File.cast();
                      print('Pointer cast complete: $mp3File2');
                      cowbellSample = bass.BASS_SampleLoad(
                          0, // mem: use file instead of memory
                          mp3File2, // *file: file pointer
                          0, // offset: use file from the start
                          0, // length: use entire file
                          16, // max: maximum number of simultaneous playbacks
                          0 // flags: no flags set
                          );
                      print('SampleLoad complete: $cowbellSample');
                      */

                      //
                      // Approach #2: read the file into a byte data.
                      // Gives runtime error: Unhandled Exception:
                      // type '_Uint8ArrayView' is not a subtype of type
                      // 'Pointer<Void>' in type cast
                      /*
                      final ByteData bytes =
                          await rootBundle.load('assets/sounds/cowbell.mp3');
                      final mp3 = bytes.buffer.asUint8List();
                      int _length = mp3.length;
                      print('Length after rootBundle load: $_length');
                      //final ffi.Pointer<ffi.Void> mp3File =
                      //   mp3 as ffi.Pointer<ffi.Void>;
                      //print('mp3File: $mp3File');
                      cowbellSample = bass.BASS_SampleLoad(
                          1, // mem: use memory instead of file
                          mp3.cast(), // *file: memory pointer
                          0, // offset: use file from the start
                          _length, // length: use entire file
                          16, // max: maximum number of simultaneous playbacks
                          0 // flags: no flags set
                          );
                      */

                      //
                      // Approach 3: see if we can open the file using flutter
                      // throws a runtime error: no such file.  The assets
                      // are part of an archive so can't be read using file
                      // routines.
                      //
                      /*
                      String fileName = await _localFileName;
                      print('Loading file: $fileName');
                      File file = File(fileName);
                      try {
                        // Read the file
                        final contents = await file.readAsBytes();
                        if (kDebugMode) {
                          print('reading from file $fileName');
                        }
                       return;
                       } catch (e) {
                         // If encountering an error, return 0
                         if (kDebugMode) {
                           print('HF: reading from file error: $e');
                         }
                       return;
                       }
                      */

                      //
                      // approach 4: read from asset bundle into a temporary file
                      // then use approach 1 above to open it
                      // See SO "How do I get the Asset's file path in flutter?"
                      //
                      String fileName = await getMp3FileFromAssets('cowbell');
                      print('Loading file: $fileName');
                      //final ffi.Pointer<FILE> mp3File = await fileUtils.fopen(
                      //    fileName.toNativeUtf8().cast<ffi.Char>(),
                      //    "r".toNativeUtf8().cast<ffi.Char>());
                      //print('File opened: $mp3File');
                      //final ffi.Pointer<ffi.Void> mp3File2 = mp3File.cast();
                      //print('Pointer cast complete: $mp3File2');
                      cowbellStream = bass.BASS_SampleLoad(
                          0, // mem: use file instead of memory
                          fileName
                              .toNativeUtf8()
                              .cast(), // *file: file name pointer
                          0, // offset: use file from the start
                          0, // length: use entire file
                          1, // max: max number of playbacks
                          0 // flags: no flags set
                          );
                      errorCode = bass.BASS_ErrorGetCode();
                      print(
                          'BASS_SampleLoad complete!: cowbellStream = $cowbellStream, error code = $errorCode');

                      //cowbellChannel = bass.BASS_SampleGetChannel(cowbellSample, 0);
                      //print('BASS channel: $cowbellChannel');
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextButton(
                    child: Text(
                      'Play sample',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () async {
                      int _result = bass.BASS_ChannelPlay(cowbellStream, 1);
                      errorCode = bass.BASS_ErrorGetCode();
                      print(
                          'Playing sample.  Result = $_result, error code = $errorCode');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
