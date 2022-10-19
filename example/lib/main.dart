import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bass/ffi/generated_bindings.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bass/flutter_bass.dart';
//import 'package:flutter_bass/fileUtils.dart';
//import 'package:flutter_bass/file_utils/generated_bindings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // read an audio file from assets and save to a temporary file
  // This is necessary since files in the root bundle are
  // not acceissible as normal files.
  Future<String> getAudioFileFromAssets(String name) async {
    // load from the bundle
    final byteData = await rootBundle.load('assets/sounds/$name');
    final buffer = byteData.buffer;

    // build a temporary file name
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = '{$tempPath}/{$name}';

    // write the data to the temporary file
    File tempFile = await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    var length = await tempFile.length();
    print('Wrote temporary file $filePath, length = $length');

    // return the path to the temp file
    return filePath;
  }

  @override
  void initState() {
    super.initState();
  }

  int version = 0;
  int errorCode = 0;
  int cowbellSample = 0;
  int cowbellStream = 0;
  int cowbellChannel = 0;
  final infoPointer = calloc<BASS_INFO>();

  @override
  Widget build(BuildContext context) {
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
                  margin: const EdgeInsets.all(10),
                  child: TextButton(
                    child: const Text(
                      'Init BASS',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      // BASS_Init: -1 = default device, 44100 = sample rate, 0 = flags
                      bass.BASS_Init(-1, 44100, 0, ffi.nullptr, ffi.nullptr);
                      errorCode = bass.BASS_ErrorGetCode();
                      print('Error code = $errorCode');
                      // set non-stop mode to reduce playback latency
                      bass.BASS_SetConfig(BASS_CONFIG_DEV_NONSTOP, 1);

                      // set the update period to 5ms
                      bass.BASS_SetConfig(BASS_CONFIG_UPDATEPERIOD, 5);

                      // set the buffer length to 10ms
                      bass.BASS_SetConfig(BASS_CONFIG_BUFFER, 10);

                      // disable ramping-in only: NORAMP is not defined?!?
                      //bass.BASS_SetConfig(BASS_CONFIG_NORAMP, 2);

                      // print out some elements of the BASS_INFO struct
                      bass.BASS_GetInfo(infoPointer);
                      int latency = infoPointer.ref.latency;
                      int freq = infoPointer.ref.freq;
                      int minBuf = infoPointer.ref.minbuf;
                      print('Latency = $latency');
                      print('Minbuf = $minBuf');
                      print('Frequency = $freq');
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextButton(
                    child: const Text(
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
                  margin: const EdgeInsets.all(10),
                  child: TextButton(
                    child: const Text(
                      'Load sample',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () async {
                      //
                      // approach 4: read from asset bundle into a temporary file
                      // See SO "How do I get the Asset's file path in flutter?"
                      //
                      String fileName =
                          await getAudioFileFromAssets('cowbell.mp3');
                      print('Loading file: $fileName');
                      cowbellSample = bass.BASS_SampleLoad(
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
                          'BASS_SampleLoad complete!: cowbellSample = $cowbellSample, error code = $errorCode');

                      cowbellChannel =
                          bass.BASS_SampleGetChannel(cowbellSample, 0);
                      print('BASS channel: $cowbellChannel');

                      // set the playback buffering length to 0s to minimize latency
                      bass.BASS_ChannelSetAttribute(
                          cowbellChannel, BASS_ATTRIB_BUFFER, 0.0);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextButton(
                    child: const Text(
                      'Play sample',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () async {
                      int result = bass.BASS_ChannelPlay(cowbellChannel, 1);
                      errorCode = bass.BASS_ErrorGetCode();
                      print(
                          'Playing sample.  Result = $result, error code = $errorCode');
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
