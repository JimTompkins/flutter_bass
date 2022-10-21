# flutter_bass

A Flutter plugin to allow Flutter apps to use the BASS audio library
from [un4seen Developments](https://un4seen.com).

BASS is a audio library that supports (among other architectures) both iOS and Android.

The flutter_bass example app has four buttons related to BASS:
1. Init BASS: this initializes the BASS library.  If already initialized, an error code will be printed.
2. Get BASS version: prints the version of the BASS library to the console, currently 2.4.16.7
3. Load sample: loads a sample sound (in this case a cowbell) as a BASS sample using the library
function SampleLoad.  Then a channel is created using the SampleGetChannel function.
4. Play sample: plays the cowbell sound using the BASS library function ChannelPlay.

As a comparison, there are also three buttons below to use the [soundpool Flutter package](https://pub.dev/packages/soundpool):
1. Init soundpool
2. Load file in soundpool
3. Play using soundpool

<img
  src="/LatencyTesting/IMG_0034.PNG"
  alt="Example app screenshot"
  title="Example app screenshot"
  style="display: inline-block; margin: 0 auto; max-width: 300px">

## Measuring Latency

Latency can be measured using an audio recorder on another (i.e. not the one running flutter_bass) device.  For example, I use the Samsung VoiceRecorder app on a Samsung Galaxy S7.  Record audio while hitting the "Play" button on the flutter_bass app.
Try to make a sound when hitting the play button, for example by using your fingernail.  Note that this latency will include the time for Flutter to recognize the button press as well as the time to play the audio file.

Save the audio recording and then open it in an audio tool such as Audacity.  Zoom in on the waveform and
measure the time between the button press and the cowbell sound.

<img
  src="/LatencyTesting/LatencyMeasurementUsingAudacity.png"
  alt="Latency measurement using Audacity"
  title="Latency measurement using Audacity"
  style="display: inline-block; margin: 0 auto; max-width: 300px">

The mean latency with BASS on an iPhone 6 is 114.8ms (N=5) with a standard deviation of 11.3ms.  With soundpool in the same app, the mean is 237.6ms with a 12.3ms stdev. As mentioned above, these times both include the time for Flutter to recognize the button push and call the play routine.  The difference (122.8ms) is due to the speed of BASS compared to soundpool i.e. BASS is a lot faster!  The stDev is similar between BASS and soundpool, probably due to OS variation being similar.


## Things Learned During Development
- how to use ffigen to create a Flutter class from a .h file.
- that Flutter root bundle assets can't be accessed as Files
