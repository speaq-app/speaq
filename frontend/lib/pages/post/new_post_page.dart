import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets/speaq_post_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Keyboard
  bool mainKeyboardVisible = true;
/*
  bool visibilityContainer = false;
*/
  bool cameraContainerVisible = false;

  // Emoji
  bool emojiKeyboardVisible = false;

  // Camera/Gallery
  bool checkImage = false;
  File? _image = new File("assets/images/developer_sven.jpg");
  late XFile? im;

  // Audio
  final recorder = FlutterSoundRecorder();
  bool audioKeyboardVisible = false;
  bool isRecorderReady = false;
  String recordingText = "00:00";

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
        if(mainVisible! == true) {
          audioKeyboardVisible = false;
          emojiKeyboardVisible = false;
        }
        mainKeyboardVisible = mainVisible;
        break;

      case "AUDIO":
        mainKeyboardVisible = false;
        audioKeyboardVisible = !audioKeyboardVisible;
        emojiKeyboardVisible = false;
        break;

      case "EMOJI":
        mainKeyboardVisible = false;
        emojiKeyboardVisible = !emojiKeyboardVisible;
        audioKeyboardVisible = false;
        break;

      case "CAMERA":
        cameraContainerVisible = !cameraContainerVisible;
        break;

      case "BACK":
        mainKeyboardVisible = false;
        cameraContainerVisible = false;
        audioKeyboardVisible = false;
        emojiKeyboardVisible = false;
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
            Expanded(
              child: _buildPostTextField(),
            ),
            buildVisibilityContainer(),
            buildMainContainer(),
            buildOffstageEmoji(),
            buildOffstageAudio(),
          ],
        ),
      ),
    );
  }

  //region MAIN CONTAINER
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
                style: const TextStyle(fontSize: 20.0, color: Colors.black87),
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
                  contentPadding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0, right: 16.0),
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

  Visibility buildVisibilityContainer() {
    return Visibility(
      child: SizedBox(
        height: deviceSize.height * 0.1,
        width: deviceSize.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buildContainerCamera('https://i.pinimg.com/736x/61/54/18/61541805b3069740ecd60d483741e5bb.jpg'),
              buildContainerPictures('https://9to5fortnite.com/de/wp-content/uploads/2022/04/Corinna-Kopf-Twitch-Zuschauerzahlen-boomen-nach-dem-Wechsel-zu-IRL-Streams.jpg'),
              buildContainerPictures('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7k50ZmoaI9mkcYWJArxPWdkpSNf7QM8UzOd43LIj69CP2XzLkq9tD-4uz4s_Al9EJfK4&usqp=CAU'),
              buildContainerPictures('https://miscmedia-9gag-fun.9cache.com/images/thumbnail-facebook/1557376304.186_U5U7u5_n.jpg'),
              buildContainerPictures('https://media-exp1.licdn.com/dms/image/C4D03AQFFnndLd3cUog/profile-displayphoto-shrink_800_800/0/1649862939707?e=1658966400&v=beta&t=UzNwV5wS111quhYnnInTrSNO1mHknooTLsO_iceQ0d0'),
              buildContainerPictures('https://media-exp1.licdn.com/dms/image/C4D03AQFFnndLd3cUog/profile-displayphoto-shrink_800_800/0/1649862939707?e=1658966400&v=beta&t=UzNwV5wS111quhYnnInTrSNO1mHknooTLsO_iceQ0d0'),
            ],
          ),
        ),
      ),
      visible: cameraContainerVisible,
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
      offstage: !emojiKeyboardVisible,
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
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                progressIndicatorColor: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                noRecents: Text(
                  appLocale.noRecents,
                  style: TextStyle(fontSize: 20, color: Colors.black26),
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
      ..selection = TextSelection.fromPosition(TextPosition(offset: _postController.text.length));
  }

  _onBackspacePressed() {
    setState(() {
      switchOffStage("BACK");
    });
    _postController
      ..text = _postController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(TextPosition(offset: _postController.text.length));
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
  Padding buildContainerPictures(String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          getImage(false);
          setState(() {
            if (checkImage) {
              checkImage = !checkImage;
            } else {
              checkImage = true;
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(color: spqBlack, borderRadius: BorderRadius.circular(5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox.fromSize(
              size: Size.fromRadius(32), // Image radius
              child: Image.network(url, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(bool isCamera) async {
    if (isCamera) {
      im = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      im = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    setState(
      () {
        _image = File(im!.path);
      },
    );
  }

  buildContainerCamera(String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          getImage(true);
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox.fromSize(
              size: Size.fromRadius(32), // Image radius
              child: Image.network(url, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  //endregion

  //region BUILD ALL BUTTONS IN KEYBOARD

  Padding buildAudio() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: IconButton(
        icon: new Icon(Icons.multitrack_audio),
        onPressed: () {
          if (mainKeyboardVisible) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
          setState(() {
            print("Button");
            switchOffStage("AUDIO");
          });
        },
      ),
    );
  }

  Widget _buildPostTextField() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SpqPostTextField(
          suffixIcon: Visibility(
            visible: checkImage,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Image.file(_image!),
              ),
            ),
          ),
          height: double.infinity,
          maxLines: 30,
          controller: _postController,
          hintText: appLocale.newPost,
        ),
      );

  Widget _buildSendPostButton() {
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(
            Duration(seconds: 1),
            () {
              Navigator.popAndPushNamed(context, "home");
            },
          );
          return AlertDialog(
            title: Text(appLocale.createdPost),
            backgroundColor: spqLightGrey,
          );
        },
      ),
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
        height: 280,
        width: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildAudioButtonFunction(),
              StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, "0");
                  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

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
      style: ElevatedButton.styleFrom(fixedSize: Size(132, 132), shape: CircleBorder()),
      onPressed: () async {
        if (recorder.isRecording) {
          await stop();
        } else {
          await record();
        }
        setState(
          () {},
        );
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

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audiopath = File(path!);

    print('Recorded audio: $audiopath');
  }

  //endregion

  @override
  void dispose() {
    recorder.closeRecorder();
    _postController.dispose();

    super.dispose();
  }

}
