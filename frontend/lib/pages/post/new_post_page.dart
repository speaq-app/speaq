import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late Size deviceSize;
  final TextEditingController _postController = TextEditingController();
  bool emojiShowing = false;
  bool visibilityContainer = false;
  bool checkValue = false;

  @override
  void initState() {
    setState(() {
      visibilityContainer = checkValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          preferredSize: deviceSize,
          actionList: [_buildSendPostButton()],
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildPostTextField(appLocale),
            ),
            buildVisibilityContainer(),
            buildMainContainer(deviceSize),
          ],
        )

          //_buildPostTextField(appLocale),
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
              buildContainerPictures(
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
            print('Hello World');
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
        ));
  }

  Material buildMaterial(IconData icon) {
    return Material(
      child: IconButton(
        onPressed: () {},
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
          buildMaterial(Icons.emoji_emotions),
          buildMaterial(Icons.gif_box),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _postController,
                style: const TextStyle(fontSize: 20.0, color: Colors.black87),
                decoration: InputDecoration(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40,
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
          buildMaterial(Icons.send),
        ],
      ),
    );
  }

  Widget _buildPostTextField(AppLocalizations appLocale) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SpqPostTextField(
          height: double.infinity,
          minLines: 30,
          controller: _postController,
          hintText: appLocale.newPost,
        ),
      );

  Widget _buildSendPostButton() => TextButton(
        onPressed: () => print("Speaq"),
        child: Container(
          child: const Text("speaq"),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          decoration: BoxDecoration(
              border: Border.all(color: spqPrimaryBlue, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(16.0))),
        ),
      );
}

class SpqPostTextField extends StatelessWidget {
  const SpqPostTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    this.isPassword = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.width,
    this.height = 56,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    this.enabled = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool obscureText;
  final bool isPassword;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        minLines: minLines,
        maxLines: maxLines,
        obscureText: obscureText,
        readOnly: isPassword,
        keyboardType: keyboardType,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        controller: controller,
        validator: (value) => validator!(value),
        style: const TextStyle(color: spqBlack, fontSize: 16),
        enabled: enabled,
        decoration: InputDecoration(
          isDense: true,
          label: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Text(hintText,
                style: const TextStyle(
                    color: spqLightGrey, fontWeight: FontWeight.w100)),
          ),
          contentPadding: contentPadding,
          labelStyle:
              const TextStyle(color: spqLightGrey, fontWeight: FontWeight.w100),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          alignLabelWithHint: true,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: prefixIcon,
                )
              : null,
          suffixIcon: suffixIcon,
          fillColor: spqWhite,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqPrimaryBlue, width: 1.0),
          ),
          hintStyle: const TextStyle(
              color: spqLightGrey, fontSize: 16, fontWeight: FontWeight.w100),
          //hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqWhite, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: spqWhite, width: 1.0),
          ),
          border: const OutlineInputBorder(),
        ),
        onTap: onTap,
      ),
    );
  }
}
