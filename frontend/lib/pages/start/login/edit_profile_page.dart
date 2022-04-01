import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //Get Real Data, not hard coded
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
        appBar: AppBar(
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
        ),
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
                                  buildHero(context, hcImageURL, hcUsername),
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
              editProfileRow("Name", hcName, _nameController),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
              editProfileRow("Username", hcUsername, _usernameController),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
              editProfileRow(
                  "Description", hcDescription, _descriptionController),
              const Divider(
                indent: 110,
                color: spqDarkGrey,
              ),
              editProfileRow("Website", hcWebsite, _websiteController),
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

  Widget profileImage(String imageURL) {
    return Hero(
      tag: 'dash',
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          // boxShadow: const [
          //   BoxShadow(spreadRadius: 1, blurRadius: 5, color: spqDarkGrey)
          // ],
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageURL),
          ),
        ),
      ),
    );
  }

  Widget editProfileRow(
      String title, String text, TextEditingController _controller) {
    return Row(
      children: [
        editProfileTextItem(title),
        editProfileTextfieldItem(text, _controller),
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

  Widget editProfileTextfieldItem(
      String text, TextEditingController _controller) {
    return SizedBox(
      width: 240,
      child: TextField(
        //scrolling verhindern
        controller: _controller,
        minLines: 1,
        maxLines: 5,
        maxLength: 100,
        decoration: null,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildHero(BuildContext context, String imageURL, String username) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          username,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
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
    Navigator.pushNamed(context, "login");
  }

  void _saveProfile() {
    //Daten im Backend speichern
    //Pop anstatt push siehe _cancel
    //Route ändern zu profile
    Navigator.pushNamed(context, "login");
  }
}
