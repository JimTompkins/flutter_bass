import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bass/flutter_bass.dart';
import 'package:flutter_bass/fileUtils.dart';

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
    String _fileName = '$path/assets/sounds/cowbell.mp3';
    return _fileName;
  }

  @override
  void initState() {
    super.initState();
  }

  int version = 0;
  int cowbellSample = 0;
  int cowbellChannel = 0;

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
                      // BASS_Init: -1 = default device, 48000 = sample rate, 0 = flags
                      bass.BASS_Init(-1, 48000, 0, ffi.nullptr, ffi.nullptr);
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

                      String fileName = await _localFileName;
                      print('Loading file: $fileName');
//                      Pointer<Void> mp3Buff = fileUtils.openFile(fileName as Pointer<Char>) as Pointer<Void>;
                      ffi.Pointer<ffi.Void> mp3File = fileUtils.fopen(
                              fileName.toNativeUtf8().cast<ffi.Char>(),
                              "r".toNativeUtf8().cast<ffi.Char>())
                          as ffi.Pointer<ffi.Void>;
                      cowbellSample = bass.BASS_SampleLoad(
                          0, // mem: use file instead of memory
                          mp3File, // *file: file pointer
                          0, // offset: use file from the start
                          0, // length: use entire file
                          16, // max: maximum number of simultaneous playbacks
                          0 // flags: no flags set
                          );

                      //cowbellChannel = bass.BASS_SampleGetChannel(cowbellSample, 0);
                      //print('BASS channel: $cowbellChannel');
                      //String test = fileUtils.get_string().toString();
                      /*
                      final Pointer<Char> charPointer = fileUtils.get_string();
                      print('String from C = ${charPointer.toString()}');
                      */
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
                      //int _result = bass.BASS_ChannelPlay(cowboyChannel, 1);
                      print('Playing sample');
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
