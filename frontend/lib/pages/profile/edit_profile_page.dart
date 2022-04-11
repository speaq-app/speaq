import 'dart:developer';
import 'package:flutter/material.dart';
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
      "https://media-exp1.licdn.com/dms/image/C4E03AQHK_V2ZcbYo0Q/profile-displayphoto-shrink_200_200/0/1625487290463?e=2147483647&v=beta&t=8cRbhYZWCi9mi7XaRfq-TkGrX_G00ZBTUOCj0T882SY";
  String hcName = "Nosakhare Omoruyi";
  String hcUsername = "nomoruyi";
  String hcDescription =
      "This is a Text about me and myself. You think thats big? Then look at my forehead!";
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
                        onTap: () => Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    _buildFullScreenProfileImage(context, hcImageURL, hcUsername),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
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
                    maxLength: maxlengthName, controller: _nameController, label: "Name"),
                SpeaqTextField(
                    maxLength: maxlengthUsername,
                    controller: _usernameController,
                    label: "Username"),
                SpeaqTextField(
                    maxLength: maxlengthDescription,
                    controller: _descriptionController,
                    label: "Description",
                    maxLines: 12,
                    newLines: 5),
                SpeaqTextField(
                    maxLength: maxlengthWebsite,
                    controller: _websiteController,
                    label: "Website"),
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
      ], preferredSize: deviceSize,
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

  Widget _buildFullScreenProfileImage(BuildContext context, String imageURL, String username) {
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
    if (_checkIfDataIsValid(_nameController, hcName, maxlengthName)) {
      log("Name: " + _nameController.text + "\n");
    }
    if (_checkIfDataIsValid(
        _usernameController, hcUsername, maxlengthUsername)) {
      log("Username: " + _usernameController.text + "\n");
    }
    if (_checkIfDataIsValid(
        _descriptionController, hcDescription, maxlengthDescription)) {
      log("Description: " + _descriptionController.text + "\n");
    }
    if (_checkIfDataIsValid(_websiteController, hcWebsite, maxlengthWebsite)) {
      log("Website: " + _websiteController.text + "\n");
    }
    log("...Saved");
  }

  bool _checkIfDataIsValid(
      TextEditingController controller, String originalText, int maxLength) {
    return controller.text != originalText &&
        controller.text.isNotEmpty &&
        controller.text.length < maxLength;
  }

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
