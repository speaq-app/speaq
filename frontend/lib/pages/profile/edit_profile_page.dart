import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/pages/profile/bloc/profile_bloc.dart';
import 'package:frontend/pages/profile/model/profile.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileBloc _profileBloc = ProfileBloc();

  int maxLengthName = 30;
  int maxLengthUsername = 20;
  int maxLengthDescription = 120;
  int maxLengthWebsite = 20;

  late String hcImageURL =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";
  late String profileName;
  late String profileUsername;
  late String profileDescription;
  late String profileWebsite;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Get ID
    _profileBloc.add(LoadProfile(userId: 1));
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
            child: BlocListener<ProfileBloc, ProfileState>(
              bloc: _profileBloc,
              listener: (context, state) {
                if (state is ProfileLoaded) {
                  var profile = state.profile;
                  _nameController.text = profile.name;
                  _usernameController.text = profile.username;
                  _descriptionController.text = profile.description;
                  _websiteController.text = profile.website;
                }
              },
              child: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: _profileBloc,
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ProfileLoaded) {
                    return _buildListViewWithData(context, state.profile);
                  }
                  return const Text("ups");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildListViewWithData(
    BuildContext context,
    Profile profile,
  ) {
    return ListView(
      children: [
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        _buildFullScreenProfileImage(
                            context, hcImageURL, profileUsername),
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
          maxLength: maxLengthName,
          controller: _nameController,
          label: "Name",
          icon: const Icon(Icons.drive_file_rename_outline),
        ),
        SpeaqTextField(
          maxLength: maxLengthUsername,
          controller: _usernameController,
          label: "Username",
          icon: const Icon(Icons.alternate_email_rounded),
        ),
        SpeaqTextField(
          maxLength: maxLengthDescription,
          controller: _descriptionController,
          label: "Description",
          maxLines: 12,
          newLines: 5,
          icon: Icon(Icons.format_align_left),
        ),
        SpeaqTextField(
          maxLength: maxLengthWebsite,
          controller: _websiteController,
          label: "Website",
          icon: const Icon(Icons.web),
        ),
      ],
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
    UserService userService = GRPCUserService();
    userService.updateProfile(
      id: 1,
      name: _nameController.text,
      username: _usernameController.text,
      description: _descriptionController.text,
      website: _websiteController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
    _profileBloc.close();
  }

  void _disposeController() {
    _nameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
  }
}
