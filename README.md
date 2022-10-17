# flutter_bass

A Flutter plugin to allow Flutter apps to use the BASS audio library
from [un4seen Developments](https://un4seen.com).

BASS is a audio library that supports (among other architectures) both iOS and Android.

The flutter_bass example app has four buttons:
1. Init BASS: this initializes the BASS library.  If already initialized, an error code will be printed.
2. Get BASS version: prints the version of the BASS library to the console, currently 2.4.16.7
3. Load sample: loads a sample sound (in this case a cowbell) as a BASS sample using the library
function SampleLoad.  Then a channel is created using the SampleGetChannel function.
4. Play sample: plays the cowbell sound using the BASS library function ChannelPlay.

## Measuring Latency

Latency can be measured using an audio recorder on another (i.e. not the one running flutter_bass) device.  For example, I use the Samsung VoiceRecorder app.  Record audio while hitting the "Play" button on the flutter_bass app.
Try to make a sound when hitting the play button, for example by using your fingernail.

Save the audio recording and then open it in an audio tool such as Audacity.  Zoom in on the waveform and
measure the time between the button press and the cowbell sound.

The current result is about 120ms on an iPhone 6.  For comparison, I've achieved 70ms with the soundpool Flutter package and about 20ms on Android using the flutter_ogg_piano app which uses the Oboe audio library.

## Things Learned During Development
- how to use ffigen to create a Flutter class from a .h file.
- that Flutter root bundle assets can't be accessed as Files
