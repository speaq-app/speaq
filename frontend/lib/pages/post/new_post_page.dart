import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets/speaq_post_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  // Main
  late Size deviceSize;
  late AppLocalizations appLocale;
  final TextEditingController _postController = TextEditingController();
  bool picAndAudioOffstateVisible = false;

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
  String fileName = 'recordedAudio.aac';
  late String path;
  bool audioKeyboardVisible = false;
  bool isRecorderReady = false;
  bool isRecording = false;
  String _recorderTxt = '00:00:00';

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

    // Initialize Recorder for Audio
    initRecorder();

    // KEYBOARD VISIBILITY
    keyboardInput();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    appLocale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          actionList: [_buildSendPostButton()],
        ),
        body: Column(
          children: [
            buildPicAndAudioContainerTop(),
            Expanded(
              child: _buildPostTextField(),
            ),
            buildCameraAndGalleryVisibleContainer(),
            buildMainContainer(),
            buildOffstageEmoji(),
            buildOffstageAudio(),
          ],
        ),
      ),
    );
  }

  //region MAIN CONTAINER

  Visibility buildPicAndAudioContainerTop() {
    return Visibility(
      visible: picAndAudioOffstateVisible,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: deviceSize.width,
        height: deviceSize.height * 0.1,
        color: spqPrimaryBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "       ",
                style: TextStyle(color: spqPrimaryBlue),
              ),
            ),
            Center(
              child: dataIsAudio
                  ? InkWell(
                      onTap: () => print("test"),
                      child: SvgPicture.asset(                          "assets/images/logo/speaq_logo_white.svg"),)
                  : Image.file(
                      _imageFile!,
                      alignment: Alignment.center,
                    ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete_forever_rounded,
                    color: spqErrorRed),
                onPressed: () {
                  setState(
                    () {
                      picAndAudioOffstateVisible = !picAndAudioOffstateVisible;
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMainContainer() {
    return SizedBox(
      height: deviceSize.height * 0.08,
      child: Row(
        children: [
          buildMaterial(Icons.emoji_emotions, emojiClick),
          buildMaterial(Icons.gif_box, null),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                autofocus: true,
                controller: _postController,
                style: const TextStyle(fontSize: 20.0, color: spqBlack),
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(
                          () {
                            switchOffStage("CAMERA");
                          },
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        size: 24,
                      ),
                    ),
                  ),
                  hintText: 'Speaq',
                  contentPadding: const EdgeInsets.only(
                      left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
          ),
          buildAudio(),
        ],
      ),
    );
  }

  Visibility buildCameraAndGalleryVisibleContainer() {
    return Visibility(
      child: Container(
        height: deviceSize.height * 0.1,
        color: spqLightGrey,
        width: deviceSize.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildContainerCamera(),
            Container(width: 6, color: spqWhite),
            buildContainerGallery(),
          ],
        ),
      ),
      visible: cameraOffstateVisible,
    );
  }

  Material buildMaterial(IconData icon, void Function()? onPressed) {
    return Material(
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: spqBlack,
        ),
      ),
    );
  }

  //endregion

  //region EMOJI
  Offstage buildOffstageEmoji() {
    return Offstage(
      offstage: !emojiKeyboardOffstateVisible,
      child: SizedBox(
        height: 280,
        child: EmojiPicker(
            onEmojiSelected: (Category category, Emoji emoji) {
              onEmojiSelected(emoji);
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
                  style: TextStyle(fontSize: 20, color: spqBlack),
                  textAlign: TextAlign.center,
                ),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL)),
      ),
    );
  }

  onEmojiSelected(Emoji emoji) {
    _postController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _postController.text.length));
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

  void emojiClick() {
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
  Padding buildContainerGallery() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          getImage(false);
          setState(
            () {
              _imageFile = File(im!.path);
              dataIsAudio = false;
              picAndAudioOffstateVisible = true;
              if (checkImageVisible) {
                checkImageVisible = !checkImageVisible;
              } else {
                checkImageVisible = true;
              }
              audioKeyboardVisible = true;
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: spqLightGrey, borderRadius: BorderRadius.circular(5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox.fromSize(
              size: Size.fromRadius(32), // Image radius
              child:
                  Image.asset('assets/images/gallery.png', fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(bool isCamera) async {
    if (isCamera) {
      im = (await ImagePicker.platform.pickImage(source: ImageSource.camera))!;
    } else {
      im = (await ImagePicker.platform.pickImage(source: ImageSource.gallery))!;
    }
  }

  buildContainerCamera() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          getImage(true);
        },
        child: Container(
          decoration: BoxDecoration(
            color: spqLightGrey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox.fromSize(
              size: Size.fromRadius(32), // Image radius
              child: const Image(
                  image: AssetImage('assets/images/camera.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  //endregion*/

  //region BUILD ALL BUTTONS IN KEYBOARD

  Padding buildAudio() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(Icons.multitrack_audio),
        onPressed: () {
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

  Widget _buildPostTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SpqPostTextField(
        height: double.infinity,
        maxLines: 30,
        controller: _postController,
        hintText: appLocale.newPost,
      ),
    );
  }

  Widget _buildSendPostButton() {
    return TextButton(
      onPressed: () {
        picAndAudioOffstateVisible = false;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(
              Duration(seconds: 3),
              () {
                Navigator.popAndPushNamed(context, "home");
              },
            );
            return const Center(
              child: SizedBox(
                height: 72,
                width: 72,
                child: CircularProgressIndicator(strokeWidth: 8),
              ),
            );
          },
        );
      },
      child: Container(
        child: const Text("Speaq"),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        decoration: BoxDecoration(
          border: Border.all(color: spqPrimaryBlue, width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
    );
  }

  //endregion

  //region AUDIO
  Offstage buildOffstageAudio() {
    return Offstage(
      offstage: !audioKeyboardVisible,
      child: SizedBox(
        height: deviceSize.height * 0.333,
        width: deviceSize.width * 0.25,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  color: spqPrimaryBlue,
                  icon: Icon(
                    Icons.refresh,
                    color: spqWhite,
                  ),
                  onPressed: () {
                    setState(() {});
                  }),
              buildAudioButtonFunction(),
              StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  String twoDigitMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  String twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      child: Icon(recorder.isRecording ? Icons.stop : Icons.mic, size: 32),
      style: ElevatedButton.styleFrom(
          fixedSize: Size(132, 132), shape: CircleBorder()),
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
              picAndAudioOffstateVisible = !picAndAudioOffstateVisible;
            },
          );
        }
      },
    );
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    final directory = await getApplicationDocumentsDirectory();
    path = directory.path;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
    await initializeDateFormatting();
  }

  Future record() async {
    if (!isRecorderReady) return;
    //await recorder.startRecorder(toFile: 'audio');
    print('recording....');
    await recorder!.startRecorder(
      toFile: '$fileName',
      //codec: Codec.aacMP4,
    );
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
  void dispose() {
    recorder.closeRecorder();
    _postController.dispose();

    isRecorderReady = false;
    super.dispose();
  }
}
