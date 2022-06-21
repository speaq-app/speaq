import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SpqAudioPostContainer extends StatefulWidget {
  const SpqAudioPostContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<SpqAudioPostContainer> createState() => _SpqAudioPostContainerState();
}

class _SpqAudioPostContainerState extends State<SpqAudioPostContainer> {
  bool isPlaying = false;

  Duration duration = Duration.zero;

  Duration position = Duration.zero;

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    final player = AudioCache(prefix: 'assets/audio/');
    final url = await player.load('audio.mp3');
    audioPlayer.setUrl(url.path, isLocal: true);
  }

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    //Change from Hardcoded
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          min: 0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          onChanged: (value) async {
            final position = Duration(seconds: value.toInt());
            await audioPlayer.seek(position);
            await audioPlayer.resume();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatTime(position),
              ),
              Text(
                formatTime(duration - position),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 35,
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            iconSize: 50,
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.resume();
              }
            },
          ),
        ),
      ],
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours < 0) hours, minutes, seconds].join(":");
  }
}
