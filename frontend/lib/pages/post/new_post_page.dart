import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/blocs/post_bloc/post_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets/speaq_audio_post_container.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _postBloc = PostBloc();
  FlutterSoundPlayer? _player;
  FlutterSoundRecorder? _recorder;
  final ValueNotifier<bool?> _isRecordingNotifier = ValueNotifier<bool?>(false);
  final _picker = ImagePicker();
  final _keyboardVisibilityController = KeyboardVisibilityController();
  final _postController = TextEditingController();


  var _hasMicrophoneAccess = true;
  var _postAttachment = _PostAttachments.none;
  var _activeKeyboard = _Keyboards.none;

  final _recordedAudio = <int>[];
  var _audioDuration = Duration.zero;
  StreamSubscription? _recordingDataSubscription;
  StreamSubscription? _keyboardSubscription;
  final _jpegEncoder = image.JpegEncoder(quality: 30);
  XFile? _pickedImage;

  String spqImage = "assets/images/logo/speaq_logo.svg";

  void _switchKeyboard(_Keyboards keyboard) {
    if (keyboard != _Keyboards.buildIn) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    if (_activeKeyboard == keyboard) {
      _activeKeyboard = _Keyboards.none;
    } else {
      _activeKeyboard = keyboard;
    }

    if (_recorder?.isRecording ?? false) {
      _recorder!.stopRecorder();
      _isRecordingNotifier.value = false;

    }
  }

  @override
  void initState() {
    super.initState();

    _initPlayer();
    _initRecorder();
    _initKeyboard();
  }

  Future<void> _initPlayer() async {
    _player = await FlutterSoundPlayer().openPlayer();
  }

  /// Checks if user has given a permission to access the device's microphone.
  ///
  /// Throws an [Exception] if microphone is not permitted.
  Future<void> _initRecorder() async {
    var status = await Permission.microphone.request();
    _hasMicrophoneAccess = status == PermissionStatus.granted;

    if (!_hasMicrophoneAccess) {
      throw 'Microphone permission not granted';
    }

    _recorder = await FlutterSoundRecorder().openRecorder();
    _recorder?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
  }

  void _initKeyboard() {
    _keyboardSubscription = _keyboardVisibilityController.onChange.listen(
      (bool keyboardShowing) {
        if (!keyboardShowing) {
          return;
        }

        setState(() {
          _switchKeyboard(_Keyboards.buildIn);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: KeyboardDismissOnTap(
          dismissOnCapturedTaps: true,
          child: BlocConsumer<PostBloc, PostState>(
            bloc: _postBloc,
            listener: (context, state) async {
              if (state is PostSaved) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is PostProcessing) {
                return SpqLoadingWidget(
                  MediaQuery.of(context).size.shortestSide * 0.15,
                  child: Text(state.message),
                );
              }
              if (state is PostSaving) {
                return SpqLoadingWidget(
                  MediaQuery.of(context).size.shortestSide * 0.15,
                  child: Text(appLocale.uploadingPost),
                );
              } else {
                return Scaffold(
                  appBar: SpqAppBar(
                    preferredSize: deviceSize,
                    actionList: [
                      _buildSendPostButton(appLocale),
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: _buildAttachmentPreview(deviceSize),
                      ),
                      _buildInputRow(),
                      _buildEmojiKeyboard(appLocale),
                      _buildAudioKeyboard(deviceSize),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  /// Uses case for audio or image depending on what [_PostAttachments] and saves in [_postAttachment].
  Widget _buildAttachmentPreview(Size deviceSize) {
    switch (_postAttachment) {
      case _PostAttachments.none:
        return Opacity(
          opacity: 0.2,
          child: SvgPicture.asset(
            spqImage,
            height: deviceSize.height * 0.2,
            alignment: Alignment.center,
          ),
        );
      // Generating [Container] to show user the selected image.
      case _PostAttachments.image:
        return Container(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Image.file(
                  File(_pickedImage!.path),
                ),
              ),
              // An Option to delete the image.
              IconButton(
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: spqErrorRed,
                ),
                onPressed: () {
                  setState(() {
                    _postAttachment = _PostAttachments.none;
                  });
                },
              ),
            ],
          ),
        );
      case _PostAttachments.audio:
        return Container(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Generating [SizedBox] to show user that an audio was created.
              SizedBox(
                height: 69,
                child: SpqAudioPostContainer(
                  audioData: Uint8List.fromList(_recordedAudio),
                  durationInMillis: _audioDuration.inMilliseconds,
                ),
              ),
              // An Option to delete the audio.
              IconButton(
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: spqErrorRed,
                ),
                onPressed: () {
                  setState(() {
                    _postAttachment = _PostAttachments.none;
                  });
                },
              ),
            ],
          ),
        );
    }
  }

  /// Generating [TextFormField] for user input.
  /// Opens two more options for Camera and Gallery [SpeedDialChild] when clicked.
  Widget _buildInputRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpeedDial(
            childrenButtonSize: const Size(64, 64),
            onOpen: () {
              if (_recorder!.isRecording) {
                _recorder!.stopRecorder();
                _isRecordingNotifier.value = false;
                setState(() {
                  _audioDuration = Duration.zero;
                });
              }
            },
            spaceBetweenChildren: 4,
            buttonSize: const Size(34, 34),
            childPadding: const EdgeInsets.only(left: 18),
            children: [
              // Camera
              SpeedDialChild(
                child: const Icon(Icons.camera_alt, color: spqBlack),
                onTap: () async {
                  await _pickImage(ImageSource.camera);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.image, color: spqBlack),
                onTap: () async {
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
            child: const Icon(
              Icons.add,
              size: 42,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              autofocus: true,
              controller: _postController,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 18.0, color: spqBlack),
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _switchKeyboard(_Keyboards.emoji);
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      size: 30,
                      color: spqBlack,
                    ),
                  ),
                ),
                hintText: 'Speaq',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
        ),
        // Opens audio keyboard when clicked.
        _buildAudioRecordButton(),
      ],
    );
  }

  /// Get access to device resources [ImageSource.gallery] an [ImageSource.camera] and save in [_pickedImage].
  Future<void> _pickImage(ImageSource imageSource) async {
    var newImage = await _picker.pickImage(source: imageSource);
    if (newImage == null) {
      return;
    }

    _pickedImage = newImage;

    setState(() {
      _postAttachment = _PostAttachments.image;
    });
  }

  /// Shows a keyboard of emojis and displays the recent used emojis.
  Widget _buildEmojiKeyboard(AppLocalizations appLocale) {
    return Visibility(
      visible: _activeKeyboard == _Keyboards.emoji,
      child: SizedBox(
        height: 280,
        child: EmojiPicker(
          onEmojiSelected: (Category category, Emoji emoji) {
            _onEmojiSelected(emoji);
          },
          onBackspacePressed: _onBackspacePressed,
          config: Config(
            columns: 7,
            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            initCategory: Category.RECENT,
            bgColor: const Color(0xFFF2F2F2),
            indicatorColor: spqPrimaryBlue,
            iconColor: spqLightGrey,
            iconColorSelected: spqPrimaryBlue,
            progressIndicatorColor: spqPrimaryBlue,
            backspaceColor: spqPrimaryBlue,
            skinToneDialogBgColor: spqWhite,
            skinToneIndicatorColor: spqLightGrey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            noRecents: Text(
              appLocale.noRecents,
              style: const TextStyle(fontSize: 20, color: spqBlack),
              textAlign: TextAlign.center,
            ),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
          ),
        ),
      ),
    );
  }

  /// Saves selected emojis in [_postController].
  void _onEmojiSelected(Emoji emoji) {
    _postController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _postController.text.length),
      );
  }

  void _onBackspacePressed() {
    setState(() {
      _switchKeyboard(_Keyboards.none);
    });
    _postController
      ..text = _postController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _postController.text.length),
      );
  }

  /// Changes the icon depending on whether the microphone is allowed by the user.
  Widget _buildAudioRecordButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon((_hasMicrophoneAccess) ? Icons.mic : Icons.mic_off),
        iconSize: 32,
        onPressed: () {
          if (!_hasMicrophoneAccess) {
            return;
          }

          setState(() {
            _switchKeyboard(_Keyboards.audio);
          });
        },
      ),
    );
  }

  Widget _buildSendPostButton(AppLocalizations appLocale) {
    return TextButton(
      onPressed: () async {
        setState(() {
          _switchKeyboard(_Keyboards.none);
        });
        _createPost(appLocale);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: spqPrimaryBlue, width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: spqPrimaryBlue,
        ),
        child: Row(
          children: const [
            Text(
              "Speaq",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: spqWhite,
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.send,
              size: 16,
              color: spqWhite,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createPost(AppLocalizations appLocale) async {
    Uint8List? data;
    String? mimeType;
    String description = _postController.text.trim();

    switch (_postAttachment) {
      case _PostAttachments.audio:
        data = Uint8List.fromList(_recordedAudio);
        mimeType = "audio/pcm16";
        break;
      case _PostAttachments.image:
        _postBloc.add(ProcessingPost("${appLocale.processing} 0%"));
        data = await _pickedImage!.readAsBytes();
        var decoder = image.findDecoderForData(data);
        if (decoder == null) {
          return _errorUnsupportedImageType(appLocale);
        }

        if (decoder.runtimeType == image.GifDecoder) {
          mimeType = "image/gif";
          break;
        }

        _postBloc.add(ProcessingPost("${appLocale.processing} 30%"));
        var img = await foundation.compute(decoder.decodeImage, data);
        if (img == null) {
          return _errorWhileDecodingImage(appLocale);
        }

        _postBloc.add(ProcessingPost("${appLocale.processing} 60%"));

        var jpegData = await foundation.compute(_jpegEncoder.encodeImage, img);
        data = Uint8List.fromList(jpegData);
        mimeType = "image/jpeg";
        break;
      case _PostAttachments.none:
        if (description.isEmpty) {
          return _errorEmptyPost(appLocale);
        }
        break;
    }

    _postBloc.add(ProcessingPost("${appLocale.processing} 100%"));

    if (data != null && data.length > maxPostAttachmentSize) {
      return _errorAttachmentTooBig(appLocale);
    }

    _postBloc.add(CreatePost(
      description: _postController.text,
      resourceData: data,
      resourceMimeType: mimeType,
      audioDuration: _audioDuration,
    ));
  }

  void _errorEmptyPost(AppLocalizations appLocale) {
    _errorFlushbar(appLocale.errorPostIsEmpty);
  }

  void _errorAttachmentTooBig(AppLocalizations appLocale) {
    _errorFlushbar(appLocale.errorPostAttachmentTooBig);
  }

  void _errorWhileDecodingImage(AppLocalizations appLocale) {
    _errorFlushbar(appLocale.errorWhileDecodingImage);
  }

  void _errorUnsupportedImageType(AppLocalizations appLocale) {
    _errorFlushbar(appLocale.errorUnsupportedImageType);
  }

  void _errorFlushbar(String message) {
    setState(() {
      Flushbar(
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: spqWhite),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: spqPrimaryBlue,
      ).show(context);
      _postAttachment = _PostAttachments.none;
    });
  }

  /// Updates the numbers of the running audio.
  ///
  /// ```dart
  /// Returns e.g. 00:12
  /// ```
  Widget _buildAudioKeyboard(Size deviceSize) {
    return Visibility(
      visible: _activeKeyboard == _Keyboards.audio,
      child: SizedBox(
        height: deviceSize.height * 0.333,
        width: deviceSize.width * 0.25,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAudioButtonFunction(),
              StreamBuilder<RecordingDisposition>(
                stream: _recorder?.onProgress,
                builder: (context, snapshot) {
                  _audioDuration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  String twoDigitMinutes = twoDigits(_audioDuration.inMinutes.remainder(60));
                  String twoDigitSeconds = twoDigits(_audioDuration.inSeconds.remainder(60));

                  return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Starting or stopping the recording depends on the status of [_recorder] and overrides [_postAttachment].
  Widget _buildAudioButtonFunction() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(132, 132),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        if (_recorder == null) {
          return;
        }

        if (_recorder!.isRecording) {
          await _recorder?.stopRecorder();
          _isRecordingNotifier.value = false;

          setState(() {
            _postAttachment = _PostAttachments.audio;
          });
        } else {
          await _record();
          setState(() {
            _postAttachment = _PostAttachments.none;
          });
        }
      },
      child: ValueListenableBuilder(
        valueListenable: _isRecordingNotifier,
        builder: (BuildContext context, bool? value, Widget? child) {
          return Icon(
            value ?? false ? Icons.stop : Icons.mic,
            size: 32,
          );
        },
/*
        child: Icon(
          _recorder?.isRecording ?? false ? Icons.stop : Icons.mic,
          size: 32,
        ),
*/
      ),
    );
  }

  /// Starts recording audio when [_recorder] is activated.
  Future<void> _record() async {
    if (_recorder == null) {
      return;
    }

    _recordedAudio.clear();
    var recordingDataController = StreamController<Food>();
    _recordingDataSubscription = recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        _recordedAudio.addAll(buffer.data!);
      }
    });

    await _recorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
    );
    _isRecordingNotifier.value = true;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _postBloc.close();
    _player?.closePlayer();
    _recorder?.closeRecorder();
    _recordingDataSubscription?.cancel();
    _keyboardSubscription?.cancel();
    _postController.dispose();
  }
}

enum _PostAttachments {
  none,
  image,
  audio,
}

enum _Keyboards {
  none,
  buildIn,
  emoji,
  audio,
}
