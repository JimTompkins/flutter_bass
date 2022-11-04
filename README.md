# flutter_bass

A Flutter plugin to allow Flutter apps to use the BASS audio library
from [un4seen Developments](https://un4seen.com).

BASS is an audio library that supports (among other architectures) both iOS and Android.

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

Finally, as a further comparison, there are three buttons to use the [flutter_ogg_piano Flutter package]
(https://pub.dev/packages/flutter_ogg_piano). (Note that these buttons are not shown in the image below.)
1. Init flutter_ogg_piano
2. Load file in flutter_ogg_piano
3. Play using flutter_ogg_piano

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

### Results Summary

The following table compares the button-press-to-playback latency of the different sound libraries/plugins on the devices I've tested so far.  As mentioned above, these latencies all include the time for the OS to recognize the button press so are not a true absolute measure of the playback latency of the sound library; they are however useful for relative comparisons.

| Sound library/plugin | Device            | Mean Latency (N=5) | Latency Stdev (N=5) |
| :---                 | :---              | :---:              | :---:         |
| BASS 2.4             | iPhone 6          | 115ms              |  11.3ms |
| Soundpool            | iPhone 6          | 238ms              | 12.3ms |
| BASS 2.4             | Samsung Galaxy S7 | 153ms              | 5.6ms |
| flutter_ogg_piano    | Samsung Galaxy S7 | 158ms              | 5.9ms |

To achieve the Android BASS result above, some tweaking was required to get from the first working result of 267ms (yikes!) to the improved result of 153ms:
- setting the frequency to 48000 (instead of 44100) reduced the mean latency by 68ms.  With the original setting of 44100, this error message resulted: 
```W/AudioTrack(29616): AUDIO_OUTPUT_FLAG_FAST denied by client; transfer 1, track 44100 Hz, output 48000 Hz.```
- With the modified setting of 48000, the message became:
```[   +6 ms] I/AudioTrack(29616): AUDIO_OUTPUT_FLAG_FAST successful; frameCount 480 -> 480```
- setting BASS_CONFIG_DEV_BUFFER to 10ms reduced the mean latency by 45ms.

My conclusions:
- for lowest playback latency, use BASS on iOS and Android.
- on iOS and Android, the latency stdev is similar between BASS and either Soundpool or flutter_ogg_piano, probably due to the variation from OS being similar.


## Lessons Learned During Development
- how to use ffigen to create a Flutter class from a .h file.
- that Flutter root bundle assets can't be accessed as Files
- when using BASS, SetConfig won't have any effect when called after Init.
- for Android, set the BASS_CONFIG_DEV_BUFFER low e.g. 10ms
- for Android, set the frequency to 48000 instead of 44100 for low latency  
