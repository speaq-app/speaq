import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/api/protos/user.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String hcImageURL =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";
  String hcName = "Informatics";
  String hcUsername = "hhn";
  String hcDescription = "I like Hochschule Heilbronn";
  String hcWebsite = "open2work.blm";

  //Limits
  final int maxlengthName = 20;
  final int maxlengthUsername = 20;
  final int maxlengthDescription = 120;
  final int maxlengthWebsite = 20;

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
    Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(deviceSize),
          body: Container(
            padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        _buildFullScreenProfileImage(
                                            context, hcImageURL, hcUsername),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return child;
                                })),
                        child: _buildProfileImage(hcImageURL),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SpeaqTextField(
                  maxLength: maxlengthName,
                  controller: _nameController,
                  label: "Name",
                  icon: const Icon(Icons.drive_file_rename_outline),
                ),
                SpeaqTextField(
                  maxLength: maxlengthUsername,
                  controller: _usernameController,
                  label: "Username",
                  icon: const Icon(Icons.alternate_email_rounded),
                ),
                SpeaqTextField(
                  maxLength: maxlengthDescription,
                  controller: _descriptionController,
                  label: "Description",
                  maxLines: 12,
                  newLines: 5,
                  icon: Icon(Icons.format_align_left),
                ),
                SpeaqTextField(
                  maxLength: maxlengthWebsite,
                  controller: _websiteController,
                  label: "Website",
                  icon: const Icon(Icons.web),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Size deviceSize) {
    return SpqAppBar(
      title: const Text(
        "Edit Profile",
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: TextButton(
        onPressed: _cancel,
        child: const Text(
          "Cancel",
          style: TextStyle(
            color: spqPrimaryBlue,
          ),
        ),
      ),
      leadingWidth: 80,
      actionList: [
        TextButton(
          onPressed: _saveProfile,
          child: const Text(
            "Done",
            style: TextStyle(
              color: spqPrimaryBlue,
            ),
          ),
        ),
      ],
      preferredSize: deviceSize,
    );
  }

  Widget _buildProfileImage(String imageURL) {
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

  Widget _buildFullScreenProfileImage(
      BuildContext context, String imageURL, String username) {
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
    Navigator.pop(context);
  }

  void _saveProfile() {
    _saveData();
    Navigator.pop(context);
  }

  void _saveData() {
    //Daten tatsächlich im Backend speichern
    log("Saving...");
    UserService.updateProfile(
        1,
        UpdateUserProfileRequest()
          ..name = _nameController.text
          ..username = _usernameController.text
          ..description = _descriptionController.text
          ..website = _websiteController.text);
    log("...Saved");
  }

  // bool _checkIfDataIsValid(TextEditingController controller, String originalText, int maxLength) {
  //   return controller.text != originalText && controller.text.isNotEmpty && controller.text.length < maxLength;
  // }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
  }

  void _disposeController() {
    _nameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
  }
}
