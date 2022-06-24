import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/blocs/post_bloc/post_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets/speaq_audio_post_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key, required this.userID}) : super(key: key);
  final int userID;

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  FlutterSoundPlayer player = FlutterSoundPlayer();

  // Main
  final PostBloc _postBloc = PostBloc();
  final TextEditingController _postController = TextEditingController();
  bool picAndAudioOffstateVisible = false;
  String resourceMimeType = "";

  // Keyboard
  bool mainKeyboardVisible = true;
  bool cameraOffstateVisible = false;

  // Emoji
  bool emojiKeyboardOffstateVisible = false;

  // Camera/Gallery
  bool checkImageVisible = false;
  String pathImageFile = "";
  late File? _imageFile = File(pathImageFile);
  late PickedFile im;

  bool dataIsAudio = false;

  // Audio
  late final recorder = FlutterSoundRecorder();
  bool audioKeyboardVisible = false;
  bool isRecorderReady = false;
  bool isRecording = false;
  bool _hasMicrophoneAccess = true;
  final _audio = <int>[];
  StreamSubscription? _mRecordingDataSubscription;
  Duration audioDuration = Duration.zero;

  //region GENERAL
  void keyboardInput() {
    KeyboardVisibility.onChange.listen(
      (bool keyboardShowing) {
        setState(
          () {
            switchOffStage("MAIN", mainVisible: keyboardShowing);
          },
        );
      },
    );
  }

  void switchOffStage(String offstage, {bool? mainVisible}) {
    switch (offstage) {
      case "MAIN":
        if (mainVisible! == true) {
          audioKeyboardVisible = false;
          emojiKeyboardOffstateVisible = false;
        }
        mainKeyboardVisible = mainVisible;
        break;

      case "AUDIO":
        mainKeyboardVisible = false;
        audioKeyboardVisible = !audioKeyboardVisible;
        emojiKeyboardOffstateVisible = false;
        break;

      case "EMOJI":
        mainKeyboardVisible = false;
        emojiKeyboardOffstateVisible = !emojiKeyboardOffstateVisible;
        audioKeyboardVisible = false;
        break;

      case "CAMERA":
        cameraOffstateVisible = !cameraOffstateVisible;
        break;

      case "BACK":
        mainKeyboardVisible = false;
        cameraOffstateVisible = false;
        audioKeyboardVisible = false;
        emojiKeyboardOffstateVisible = false;
        break;
    }
  }
  //endregion

  @override
  void initState() {
    super.initState();
    player.openPlayer();

    // Initialize Recorder for Audio
    initRecorder();

    // KEYBOARD VISIBILITY
    keyboardInput();
  }

  Future initRecorder() async {
    var status = await Permission.microphone.request();
    _hasMicrophoneAccess = status == PermissionStatus.granted;

    if (!_hasMicrophoneAccess) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
    await initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return SafeArea(
      child: BlocConsumer<PostBloc, PostState>(
        bloc: _postBloc,
        listener: (context, state) async {
          if (state is PostSaved) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is PostSaving) {
            return SpqLoadingWidget(
              MediaQuery.of(context).size.shortestSide * 0.15,
            );
          } else {
            return Scaffold(
              appBar: SpqAppBar(
                preferredSize: deviceSize,
                actionList: [
                  _buildSendPostButton(),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: _buildAttachmentPreview(),
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
    );
  }

  Widget _buildAttachmentPreview() {
    return Visibility(
      visible: picAndAudioOffstateVisible,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SpqAudioPostContainer(audioUrl: Uint8List.fromList(_audio), maxDuration: audioDuration,),
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded, color: spqErrorRed),
                onPressed: () {
                  setState(
                    () {
                      picAndAudioOffstateVisible = !picAndAudioOffstateVisible;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpeedDial(
            childrenButtonSize: const Size(64, 64),
            spaceBetweenChildren: 4,
            buttonSize: const Size(34, 34),
            childPadding: const EdgeInsets.only(left: 18),
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.camera_alt, color: spqBlack),
                  onTap: () async {
                    await getImage(true);
                    setState(() {
                      _imageFile = File(im.path);
                      dataIsAudio = false;
                      picAndAudioOffstateVisible = true;
                      if (checkImageVisible) {
                        checkImageVisible = !checkImageVisible;
                      } else {
                        checkImageVisible = true;
                      }
                    });
                  }),
              SpeedDialChild(
                child: const Icon(Icons.image, color: spqBlack),
                onTap: () async {
                  await getImage(false);
                  setState(
                    () {
                      _imageFile = File(im.path);
                      dataIsAudio = false;
                      picAndAudioOffstateVisible = true;
                      if (checkImageVisible) {
                        checkImageVisible = !checkImageVisible;
                      } else {
                        checkImageVisible = true;
                      }
                    },
                  );
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
                    onPressed: _onEmojiClick,
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
        _buildAudioRecordButton(),
      ],
    );
  }

  //region EMOJI
  Offstage _buildEmojiKeyboard(AppLocalizations appLocale) {
    return Offstage(
      offstage: !emojiKeyboardOffstateVisible,
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

  _onEmojiSelected(Emoji emoji) {
    _postController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _postController.text.length),
      );
  }

  _onBackspacePressed() {
    setState(
      () {
        switchOffStage("BACK");
      },
    );
    _postController
      ..text = _postController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _postController.text.length),
      );
  }

  _onEmojiClick() {
    if (mainKeyboardVisible) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    setState(
      () {
        switchOffStage("EMOJI");
      },
    );
  }

  //endregion

  //region CAMERA/GALLERY AND FUNCTIONALITIES

  Future getImage(bool isCamera) async {
    if (isCamera) {
      im = (await ImagePicker.platform.pickImage(source: ImageSource.camera))!;
    } else {
      im = (await ImagePicker.platform.pickImage(source: ImageSource.gallery))!;
    }
  }

  //endregion*/

  //region BUILD ALL BUTTONS IN KEYBOARD

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

          if (mainKeyboardVisible) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
          setState(
            () {
              print("Button");
              switchOffStage("AUDIO");
            },
          );
        },
      ),
    );
  }

  Widget _buildSendPostButton() {
    return TextButton(
      onPressed: () {
        picAndAudioOffstateVisible = false;
        _createPost();
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

  void _createPost() {
    if(audioDuration > Duration.zero){
      resourceMimeType = "audio";
    }

    _postBloc.add(CreatePost(
      description: _postController.text,
      resourceData: Uint8List.fromList(_audio),
      resourceMimeType: resourceMimeType,
      audioDuration: audioDuration,
    ));
  }

  //endregion

  //region AUDIO
  Widget _buildAudioKeyboard(Size deviceSize) {
    return Offstage(
      offstage: !audioKeyboardVisible,
      child: SizedBox(
        height: deviceSize.height * 0.333,
        width: deviceSize.width * 0.25,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildAudioButtonFunction(),
              StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  audioDuration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  String twoDigitMinutes = twoDigits(audioDuration.inMinutes.remainder(60));
                  String twoDigitSeconds = twoDigits(audioDuration.inSeconds.remainder(60));

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

  Widget buildAudioButtonFunction() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(132, 132),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        if (recorder.isRecording) {
          await stop();
          setState(
            () {
              dataIsAudio = true;
              picAndAudioOffstateVisible = true;
            },
          );
        } else {
          await record();
          setState(
            () {
              dataIsAudio = false;
              picAndAudioOffstateVisible = false;
            },
          );
        }
      },
      child: Icon(recorder.isRecording ? Icons.stop : Icons.mic, size: 32),
    );
  }

  Future record() async {
    if (!isRecorderReady) return;
    _audio.clear();
    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription = recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        _audio.addAll(buffer.data!);
      }
    });

    await recorder.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
    );

    setState(() {});
  }

  Future stop() async {
    if (!isRecorderReady) return;
    isRecording = !isRecording;
    final path = await recorder.stopRecorder();
    final audiopath = File(path!);

    print('Recorded audio: $audiopath');
  }

  //endregion

  @override
  void dispose() async {
    super.dispose();
    player.stopPlayer();
    player.closePlayer();
    recorder.closeRecorder();
    _postController.dispose();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }

    _postBloc.close();

    isRecorderReady = false;
  }
}
