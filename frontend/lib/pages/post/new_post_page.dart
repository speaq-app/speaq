import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/widgets/speaq_post_text_field.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late Size deviceSize;
  late AppLocalizations appLocale;
  final TextEditingController _postController = TextEditingController();
  bool emojiShowing = false;
  bool keyboardShowing = true;
  bool visibilityContainer = false;
  bool checkValue = false;
  bool checkImage = false;
  File? _image = new File("assets/images/developer_sven.jpg");
  late XFile? im;

  bool isAudioClicked = false;

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

  @override
  void initState() {
    super.initState();
    setState(() {
      visibilityContainer = checkValue;
    });

    KeyboardVisibility.onChange.listen(
      (bool keyboardShowing) {
        setState(
          () {
            this.keyboardShowing = keyboardShowing;
          },
        );

        if (keyboardShowing && emojiShowing) {
          emojiShowing = false;
        } else if (keyboardShowing && isAudioClicked) {
          isAudioClicked = false;
        } else if (emojiShowing && isAudioClicked) {
          isAudioClicked = false;

        }
      },
    );
  }

  onEmojiSelected(Emoji emoji) {
    _postController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _postController.text.length));
  }

  _onBackspacePressed() {
    _postController
      ..text = _postController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _postController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    appLocale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          actionList: [_buildSendPostButton(appLocale)],
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildPostTextField(appLocale),
            ),
            buildVisibilityContainer(),
            buildMainContainer(deviceSize),
            Offstage(
              offstage: !emojiShowing,
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
            ),
            Offstage(
              offstage: !isAudioClicked,
              child: SizedBox(
                height: 280,
                child: Container(
                  alignment: Alignment.center,
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Visibility buildVisibilityContainer() {
    return Visibility(
      child: Container(
        height: deviceSize.height * 0.1,
        width: deviceSize.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buildContainerCamera(
                  'https://i.pinimg.com/736x/61/54/18/61541805b3069740ecd60d483741e5bb.jpg'),
              buildContainerPictures(
                  'https://9to5fortnite.com/de/wp-content/uploads/2022/04/Corinna-Kopf-Twitch-Zuschauerzahlen-boomen-nach-dem-Wechsel-zu-IRL-Streams.jpg'),
              buildContainerPictures(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7k50ZmoaI9mkcYWJArxPWdkpSNf7QM8UzOd43LIj69CP2XzLkq9tD-4uz4s_Al9EJfK4&usqp=CAU'),
              buildContainerPictures(
                  'https://media-exp1.licdn.com/dms/image/D4E35AQFdsSxUaOeh7A/profile-framedphoto-shrink_800_800/0/1626087039018?e=1653922800&v=beta&t=TDYjF0_qwmfYWPVN0YqoSyV4VX85zEDNMZ4OuaruY8A'),
              buildContainerPictures(
                  'https://media-exp1.licdn.com/dms/image/D4E35AQHsZeU9aUaDcA/profile-framedphoto-shrink_800_800/0/1651314690282?e=1653922800&v=beta&t=Wwe_zVZTeMQr4iizRPy8aOqc4tfGlzeIH8WuhJngTAI'),
              buildContainerPictures(
                  'https://media-exp1.licdn.com/dms/image/C4D03AQFFnndLd3cUog/profile-displayphoto-shrink_800_800/0/1649862939707?e=1658966400&v=beta&t=UzNwV5wS111quhYnnInTrSNO1mHknooTLsO_iceQ0d0'),
            ],
          ),
        ),
      ),
      visible: checkValue,
    );
  }

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
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(5)),
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

  Material buildMaterial(IconData icon, void Function()? onPressed) {
    return Material(
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    );
  }

  Container buildMainContainer(Size deviceSize) {
    return Container(
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
                    child: Container(
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(
                            () {
                              if (checkValue) {
                                checkValue = false;
                              } else {
                                checkValue = true;
                              }
                            },
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          size: 24,
                        ),
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

  Padding buildAudio() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: IconButton(
        icon: new Icon(Icons.multitrack_audio),
        onPressed: () {
          if (keyboardShowing) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
          setState(() {
            isAudioClicked = !isAudioClicked;
          });
        },
      ),
    );
  }

  Widget _buildPostTextField(AppLocalizations appLocale) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SpqPostTextField(
          suffixIcon: Visibility(
            visible: checkImage,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Container(
                  child: Image.file(_image!),
                ),
              ),
            ),
          ),
          height: double.infinity,
          maxLines: 30,
          controller: _postController,
          hintText: appLocale.newPost,
        ),
      );

  Widget _buildSendPostButton(AppLocalizations appLocale) {
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

  void emojiClick() {
    if (keyboardShowing) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    setState(
      () {
        emojiShowing = !emojiShowing;
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
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(5)),
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
}
