import 'dart:ffi';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bass/flutter_bass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
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
                const Text(
                  'Integrating BASS with Flutter',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Container(
                  margin: EdgeInsets.all(25),
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
                      }
                      // BASS_Init: -1 = default device, 48000 = sample rate, 0 = flags
                      bass.BASS_Init(-1, 48000, 0, nullptr, nullptr);
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
