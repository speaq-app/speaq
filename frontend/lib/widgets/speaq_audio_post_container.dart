import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

typedef Fn = void Function();

class SpqAudioPostContainer extends StatefulWidget {
  final Uint8List audioData;
  final Codec codec;
  final int durationInMillis;

  const SpqAudioPostContainer({
    required this.audioData,
    required this.durationInMillis,
    this.codec = Codec.pcm16,
    Key? key,
  }) : super(key: key);

  @override
  State<SpqAudioPostContainer> createState() => _SpqAudioPostContainerState();
}

class _SpqAudioPostContainerState extends State<SpqAudioPostContainer> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _playerIsInited = false;
  StreamSubscription? _playerSubscription;

  late int _duration;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _duration = widget.durationInMillis;

    init().then((value) {
      setState(() {
        _playerIsInited = true;
      });
    });
  }

  Future<void> init() async {
    await _player.openPlayer(enableVoiceProcessing: true);

    await _player.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    _playerSubscription = _player.dispositionStream()!.listen((event) {
      setState(() {
        _progress = event.position.inMilliseconds;
      });
    });
  }

  _startPlayer() async {
    var duration = await _player.startPlayer(
        fromDataBuffer: widget.audioData,
        codec: widget.codec,
        whenFinished: () {
          setState(() {});
        });
    setState(() {
      _duration = duration!.inMilliseconds;
    });
  }

  Future<void> _onPlayerSeek(double d) async {
    _progress = d.floor();
    setState(() {});
    await _player.seekToPlayer(
      Duration(milliseconds: d.floor()),
    );
  }

  _onControllButtonPressed() {
    if (!_playerIsInited) {
      return;
    }

    if (_player.isPaused) {
      _player.resumePlayer().then((value) => setState(() {}));
    } else if (_player.isStopped) {
      _startPlayer();
    } else {
      _player.pausePlayer().then((value) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          child: IconButton(
            icon: Icon(
              _player.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            iconSize: 25,
            onPressed: _onControllButtonPressed,
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: 250,
              child: Slider(
                min: 0.0,
                max: _duration.toDouble(),
                value: _progress.toDouble(),
                onChanged: _onPlayerSeek,
                onChangeEnd: _onPlayerSeek,
              ),
            ),
            Row(
              children: [
                Text(_formatTime(_progress ~/ 1000)),
                const SizedBox(width: 150),
                Text(_formatTime(_duration ~/ 1000))
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(int duration) {
    if (duration >= 60) {
      return "${duration ~/ 60}:${duration % 60}";
    }
    if (duration >= 10) {
      return "0:${duration % 60}";
    }
    return "0:0${duration % 60}";
  }

  @override
  void dispose() async {
    super.dispose();
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }

    await _player.stopPlayer();
    await _player.closePlayer();
  }
}
