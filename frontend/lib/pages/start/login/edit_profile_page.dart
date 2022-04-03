import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/utils/input_formatter/max_lines_text_input_formatter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String hcImageURL =
      "https://media-exp1.licdn.com/dms/image/C4E03AQHK_V2ZcbYo0Q/profile-displayphoto-shrink_200_200/0/1625487290463?e=2147483647&v=beta&t=8cRbhYZWCi9mi7XaRfq-TkGrX_G00ZBTUOCj0T882SY";
  String hcName = "Nosakhare Omoruyi";
  String hcUsername = "@nomoruyi";
  String hcDescription =
      "This is a Text about me and myself. You think thats long? Then look at my dick.";
  String hcWebsite = "open2work.blm";

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: hcName);
    _usernameController = TextEditingController(text: hcUsername);
    _descriptionController = TextEditingController(text: hcDescription);
    _websiteController = TextEditingController(text: hcWebsite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  _buildHero(context, hcImageURL, hcUsername),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child;
                          })),
                      child: profileImage(hcImageURL),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
              _buildEditProfileRow("Name", hcName, _nameController, 1, 30),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
              _buildEditProfileRow("Username", hcUsername, _usernameController, 1, 20),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
              _buildEditProfileRow(
                  "Description", hcDescription, _descriptionController, 5, 120),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
              _buildEditProfileRow("Website", hcWebsite, _websiteController, 1, 20),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileRow(
      String title, String text, TextEditingController _controller, int lineCount, int maxCharacterLength) {
    return Row(
      children: [
        editProfileTextItem(title),
        editProfileTextfieldItem(text, _controller, lineCount, maxCharacterLength),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Edit Profile",
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: TextButton(
        onPressed: _cancel,
        child: const Text("Cancel"),
      ),
      leadingWidth: 80,
      actions: [
        TextButton(
          onPressed: _saveProfile,
          child: const Text("Done"),
        ),
      ],
    );
  }

  Widget editProfileTextItem(String title) {
    return SizedBox(
      width: 110,
      child: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget profileImage(String imageURL) {
    return Hero(
      tag: 'dash',
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageURL),
          ),
        ),
      ),
    );
  }

  Widget editProfileTextfieldItem(
      String text, TextEditingController _controller, int lineCount, int maxCharacterLength) {
    return SizedBox(
      width: 240,
      child: TextField(
        inputFormatters: [
          MaxLinesTextInputFormatter(lineCount),
        ],
        scrollPhysics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        minLines: 1,
        maxLines: lineCount,
        maxLength: maxCharacterLength,
        decoration: null,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, String imageURL, String username) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          username,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: spqBlack,
        ),
        backgroundColor: spqWhite,
      ),
      body: Container(
        color: spqWhite,
        child: Center(
          child: Hero(
            tag: 'dash',
            child: Image.network(
              imageURL,
            ),
          ),
        ),
      ),
    );
  }

  void _cancel() {
    //pop anstatt push? Unendlicher Stack??? Wie funktioniert Routing genau?
    //Route ändern zu profile
    Navigator.pop(context, "login");
  }

  void _saveProfile() {
    _saveData();
    //Pop anstatt push siehe _cancel
    //Route ändern zu profile
    Navigator.pop(context, "login");
  }

  void _saveData() {
    //Daten tatsächlich im Backend speichern
    log("Saving...");
    if (hcName != _nameController.text) {
      log("Name: " + _nameController.text + "\n");
    }
    if (hcUsername != _usernameController.text) {
      log("Username: " + _usernameController.text + "\n");
    }
    if (hcDescription != _descriptionController.text) {
      log("Description: " + _descriptionController.text + "\n");
    }
    if (hcWebsite != _websiteController.text) {
      log("Website: " + _websiteController.text + "\n");
    }
    log("...Saved");
  }

  void _disposeController() {
    _nameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
  }
}