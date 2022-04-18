import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/profile/bloc/profile_bloc.dart';
import 'package:frontend/pages/profile/model/profile.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_loading_widget.dart';
import 'package:frontend/widgets/speaq_textfield.dart';
import 'package:shimmer/shimmer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileBloc _profileBloc = ProfileBloc();

  final String langKey = "pages.profile.";

  int maxLengthName = 30;
  int maxLengthUsername = 20;
  int maxLengthDescription = 120;
  int maxLengthWebsite = 20;

  late String hcImageURL =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) async {
            if (state is ProfileLoaded) {
              var profile = state.profile;
              _nameController.text = profile.name;
              _usernameController.text = profile.username;
              _descriptionController.text = profile.description;
              _websiteController.text = profile.website;
            } else if (state is ProfileSaved) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is ProfileSaving) {
              return SpqLoadingWidget(
                  MediaQuery.of(context).size.shortestSide * 0.15);
            } else if (state is ProfileSaved) {
              return const Center(
                child: Icon(
                  Icons.check,
                  size: 35,
                  color: spqPrimaryBlue,
                ),
              );
            } else if (state is ProfileLoading) {
              return Scaffold(
                appBar: _buildLoadingAppBar(deviceSize),
                body: Container(
                    padding:
                        const EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: _buildListViewShimmer(context)),
              );
            } else if (state is ProfileLoaded) {
              return Scaffold(
                appBar: _buildAppBar(deviceSize),
                body: Container(
                    padding:
                        const EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: _buildListViewWithData(context, state.profile)),
              );
            }
            return const Text("not workin - edit_profile_page line 81");
          },
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
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    _buildFullScreenProfileImage(
                        context, hcImageURL, _usernameController.text),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                })),
            child: _buildProfileImage(hcImageURL),
          ),
        ),
        const SizedBox(height: 40),
        _buildNameTextField(),
        _buildUsernameTextField(),
        _buildDescriptionTextField(),
        _buildWebsiteTextField(),
      ],
    );
  }

  Widget _buildNameTextField() {
    return SpeaqTextField(
      maxLength: maxLengthName,
      controller: _nameController,
      label: "Name",
      icon: const Icon(Icons.person_outline),
    );
  }

  Widget _buildUsernameTextField() {
    return SpeaqTextField(
      maxLength: maxLengthUsername,
      controller: _usernameController,
      label: "Username",
      icon: const Icon(Icons.alternate_email_rounded),
    );
  }

  Widget _buildDescriptionTextField() {
    return SpeaqTextField(
      maxLength: maxLengthDescription,
      controller: _descriptionController,
      label: "Description",
      maxLines: 12,
      newLines: 5,
      icon: const Icon(Icons.format_align_left),
    );
  }

  Widget _buildWebsiteTextField() {
    return SpeaqTextField(
      maxLength: maxLengthWebsite,
      controller: _websiteController,
      label: "Website",
      icon: const Icon(Icons.link),
    );
  }

  Widget _buildListViewShimmer(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        _buildFullScreenProfileImage(
                            context, hcImageURL, _usernameController.text),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    })),
                child: _buildProfileImage(hcImageURL),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Shimmer.fromColors(
          baseColor: spqBlack,
          highlightColor: spqLightGrey,
          child: SpeaqTextField(
            isEnabled: false,
            maxLength: maxLengthName,
            controller: _nameController,
            label: "Name",
            icon: const Icon(Icons.person_outline),
          ),
        ),
        Shimmer.fromColors(
          baseColor: spqBlack,
          highlightColor: spqLightGrey,
          child: SpeaqTextField(
            isEnabled: false,
            maxLength: maxLengthUsername,
            controller: _usernameController,
            label: "Username",
            icon: const Icon(Icons.alternate_email_rounded),
          ),
        ),
        Shimmer.fromColors(
          baseColor: spqBlack,
          highlightColor: spqLightGrey,
          child: SpeaqTextField(
            isEnabled: false,
            maxLength: maxLengthDescription,
            controller: _descriptionController,
            label: "Description",
            maxLines: 12,
            newLines: 5,
            icon: const Icon(Icons.format_align_left),
          ),
        ),
        Shimmer.fromColors(
          baseColor: spqBlack,
          highlightColor: spqLightGrey,
          child: SpeaqTextField(
            isEnabled: false,
            maxLength: maxLengthWebsite,
            controller: _websiteController,
            label: "Website",
            icon: const Icon(Icons.link),
          ),
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

  PreferredSizeWidget _buildLoadingAppBar(Size deviceSize) {
    return SpqAppBar(
      title: const Text(
        "Edit Profile",
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      preferredSize: deviceSize,
      leading: null,
      isAutomaticallyImplyLeading: false,
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
    Profile _profile = Profile(
      name: _nameController.text,
      username: _usernameController.text,
      description: _descriptionController.text,
      website: _websiteController.text,
    );
    _profileBloc.add(SaveProfile(userId: 1, profile: _profile));
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
