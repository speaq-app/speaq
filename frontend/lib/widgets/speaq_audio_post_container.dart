import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

typedef Fn = void Function();

class SpqAudioPostContainer extends StatefulWidget {
  final Uint8List audioUrl;

  const SpqAudioPostContainer({
    required this.audioUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<SpqAudioPostContainer> createState() => _SpqAudioPostContainerState();
}

class _SpqAudioPostContainerState extends State<SpqAudioPostContainer> {
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  double _mSubscriptionDuration = 0;
  Duration? maxDuration = Duration(seconds: 0);
  StreamSubscription? _mPlayerSubscription;
  int position = 0;

  FlutterSoundHelper fsh = FlutterSoundHelper();

  @override
  void initState() {
    super.initState();

    init().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    stopPlayer(_mPlayer);
    cancelPlayerSubscriptions();

    _mPlayer.closePlayer();

    super.dispose();
  }

  void cancelPlayerSubscriptions() {
    if (_mPlayerSubscription != null) {
      _mPlayerSubscription!.cancel();
      _mPlayerSubscription = null;
    }
  }

  Future<void> init() async {
    //TODO CHANGE THAT BITCH
    FlutterSoundPlayer nobodyGonnaKnow = FlutterSoundPlayer();
    nobodyGonnaKnow.openPlayer();
    maxDuration = await nobodyGonnaKnow.startPlayer(
        fromDataBuffer: widget.audioUrl,
        codec: Codec.pcm16,
        whenFinished: () {
          setState(() {});
        });
    nobodyGonnaKnow.stopPlayer();
    nobodyGonnaKnow.closePlayer();

    await _mPlayer.openPlayer(enableVoiceProcessing: true);

    await _mPlayer.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    _mPlayerSubscription = _mPlayer.dispositionStream()!.listen((event) {
      setState(() {
        _mSubscriptionDuration = event.position.inMilliseconds.toDouble();
        position = event.position.inMilliseconds;
        maxDuration = event.duration;
      });
    });
  }

  void startPlayer(FlutterSoundPlayer? player) async {
    maxDuration = await player!.startPlayer(
        fromDataBuffer: widget.audioUrl,
        codec: Codec.pcm16,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }

  Future<void> resumePlayer(FlutterSoundPlayer player) async {
    await player.resumePlayer();
  }

  Future<void> stopPlayer(FlutterSoundPlayer player) async {
    await player.stopPlayer();
  }

  Future<void> pausePlayer(FlutterSoundPlayer player) async {
    await player.pausePlayer();
  }

  Future<void> setSubscriptionDuration(double d) async {
    _mSubscriptionDuration = d;
    setState(() {});
  }

  Future<void> setPlayerPosition(double d) async {
    // _mSubscriptionDuration = d;
    setState(() {});
    await _mPlayer.seekToPlayer(
      Duration(milliseconds: d.floor()),
    );
  }

  Fn? getPlaybackFn(FlutterSoundPlayer? player) {
    if (!_mPlayerIsInited) {
      return null;
    }
    if (player!.isPaused) {
      return () {
        resumePlayer(player).then((value) => setState(() {}));
      };
    }
    return player.isStopped
        ? () {
            startPlayer(player);
          }
        : () {
            pausePlayer(player).then((value) => setState(() {}));
          };
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          child: IconButton(
            icon: Icon(
              _mPlayer.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            iconSize: 25,
            onPressed: getPlaybackFn(_mPlayer),
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: 250,
              child: Slider(
                min: 0.0,
                max: maxDuration!.inMilliseconds.toDouble(),
                value: _mSubscriptionDuration,
                onChanged: setSubscriptionDuration,
                onChangeEnd: setPlayerPosition,
              ),
            ),
            Row(
              children: [
                Text(
                  formatTime(position ~/ 1000),
                ),
                SizedBox(width: 150,),
                Text(
                  formatTime(maxDuration!.inSeconds),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String formatTime(int duration) {
    if (duration >= 60) {
      return "${duration ~/ 60}:${duration % 60}";
    }
    if (duration >= 10) {
      return "0:${duration % 60}";
    }
    return "0:0${duration % 60}";
  }
}
