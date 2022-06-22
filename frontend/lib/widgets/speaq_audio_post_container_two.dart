import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class SpqAudioPostContainerTwo extends StatefulWidget {
  final Uint8List audioUrl;

  const SpqAudioPostContainerTwo({
    required this.audioUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<SpqAudioPostContainerTwo> createState() => _SpqAudioPostContainerTwoState();
}

class _SpqAudioPostContainerTwoState extends State<SpqAudioPostContainerTwo> {
  FlutterSoundPlayer player = FlutterSoundPlayer();

  Duration duration = Duration(seconds: 20);

  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    await player.openPlayer();

    player.onProgress!.listen((event) {
      setState(() {
        position = event.position;
        duration = duration + Duration(seconds: 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: IconButton(
                icon: Icon(
                  player.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 25,
                onPressed: () async {
                  if (player.isPlaying) {
                    await player.pausePlayer();
                    setState(() {});
                  } else if (player.isPaused) {
                    await player.resumePlayer();
                    setState(() {});
                  } else {
                    await player.startPlayer(
                        fromDataBuffer: widget.audioUrl,
                        codec: Codec.mp3,
                        whenFinished: () {
                          setState(() {});
                        });
                    setState(() {});
                  }
                },
              ),
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  position = Duration(seconds: value.toInt());
                  player.updateProgress(position: position.inSeconds);
                });
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatTime(position),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  formatTime(duration - position),
                ),
              ),
            ],
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

  @override
  void dispose() {
    player.stopPlayer();
    player.closePlayer();

    super.dispose();
  }
}
