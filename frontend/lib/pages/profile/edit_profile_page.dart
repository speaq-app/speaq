import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_loading_widget.dart';
import 'package:frontend/widgets/speaq_text_field.dart';
import 'package:frontend/widgets_shimmer/shimmer_profile_picture.dart';
import 'package:shimmer/shimmer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();

  int maxLengthName = 30;
  int maxLengthUsername = 20;
  int maxLengthDescription = 120;
  int maxLengthWebsite = 20;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileBloc.add(
      LoadProfile(
        fromCache: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        // Loads the users profile on page initialization.
        // Returns to the previous page after sending the (changed) profile information to the server, if the user presses the save button.
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) async {
            if (state is ProfileLoaded) {
              var profile = state.profile;
              _nameController.text = profile.name;
              _usernameController.text = profile.username;
              _descriptionController.text = profile.description;
              _websiteController.text = profile.website;
              if (profile.profileImageResourceId > 0) {
                _resourceBloc.add(
                    LoadResource(resourceId: profile.profileImageResourceId));
              }
            } else if (state is ProfileSaved) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is ProfileSaving) {
              return SpqLoadingWidget(
                  MediaQuery.of(context).size.shortestSide * 0.15);
            } else if (state is ProfileSaved) {
              return _buildCheckScreen();
            } else if (state is ProfileLoading) {
              return Scaffold(
                appBar: _buildLoadingAppBar(deviceSize, appLocale),
                body: Container(
                  padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
                  child: _buildListViewShimmer(context, appLocale),
                ),
              );
            } else if (state is ProfileLoaded) {
              return Scaffold(
                appBar: _buildAppBar(deviceSize, state.profile, appLocale),
                body: Container(
                  padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
                  child:
                      _buildListViewWithData(context, appLocale, state.profile),
                ),
              );
            }
            return const Text("not workin - edit_profile_page line");
          },
        ),
      ),
    );
  }

  Widget _buildCheckScreen() {
    return const Center(
      child: Icon(
        Icons.check,
        size: 35,
        color: spqPrimaryBlue,
      ),
    );
  }

  ListView _buildListViewWithData(
      BuildContext context, AppLocalizations appLocale, Profile profile) {
    return ListView(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              if (profile.profileImageResourceId > 0) {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        _buildFullScreenProfileImage(context, profile.username),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    }));
              } else {
                Flushbar(
                  backgroundColor: spqPrimaryBlue,
                  messageText: const Text(
                    "📸",
                    style: TextStyle(fontSize: 256),
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(milliseconds: 500),
                ).show(context);
              }
            },
            child: _buildProfileImage(profile),
          ),
        ),
        const SizedBox(height: 40),
        _buildNameTextField(appLocale),
        _buildUsernameTextField(appLocale),
        _buildDescriptionTextField(appLocale),
        _buildWebsiteTextField(appLocale),
      ],
    );
  }

  Widget _buildNameTextField(AppLocalizations appLocale) {
    return SpeaqTextField(
      maxLength: maxNameLength,
      controller: _nameController,
      label: appLocale.name,
      icon: const Icon(Icons.person_outline),
    );
  }

  Widget _buildUsernameTextField(AppLocalizations appLocale) {
    return SpeaqTextField(
      maxLength: maxUsernameLength,
      controller: _usernameController,
      label: appLocale.username,
      icon: const Icon(Icons.alternate_email_rounded),
    );
  }

  Widget _buildDescriptionTextField(AppLocalizations appLocale) {
    return SpeaqTextField(
      maxLength: maxDescriptionLength,
      controller: _descriptionController,
      label: appLocale.description,
      maxLines: 12,
      newLines: 5,
      icon: const Icon(Icons.format_align_left),
    );
  }

  Widget _buildWebsiteTextField(AppLocalizations appLocale) {
    return SpeaqTextField(
      maxLength: maxWebsiteLength,
      controller: _websiteController,
      label: appLocale.website,
      icon: const Icon(Icons.link),
    );
  }

  Widget _buildListViewShimmer(
      BuildContext context, AppLocalizations appLocale) {
    return ListView(
      children: [
        const Center(
            child: ShimmerProfilePicture(
          diameter: 36.5,
        )),
        const SizedBox(height: 40),
        _buildNameTextFieldShimmer(appLocale),
        _buildUsernameTextFieldShimmer(appLocale),
        _buildDescriptionTextFieldShimmer(appLocale),
        _buildWebsiteTextFieldShimmer(appLocale),
      ],
    );
  }

  Widget _buildNameTextFieldShimmer(AppLocalizations appLocale) {
    return Shimmer.fromColors(
      baseColor: spqBlack,
      highlightColor: spqLightGrey,
      child: SpeaqTextField(
        isEnabled: false,
        maxLength: maxNameLength,
        controller: _nameController,
        label: appLocale.name,
        icon: const Icon(Icons.person_outline),
      ),
    );
  }

  Widget _buildUsernameTextFieldShimmer(AppLocalizations appLocale) {
    return Shimmer.fromColors(
      baseColor: spqBlack,
      highlightColor: spqLightGrey,
      child: SpeaqTextField(
        isEnabled: false,
        maxLength: maxUsernameLength,
        controller: _usernameController,
        label: appLocale.username,
        icon: const Icon(Icons.alternate_email_rounded),
      ),
    );
  }

  Widget _buildDescriptionTextFieldShimmer(AppLocalizations appLocale) {
    return Shimmer.fromColors(
      baseColor: spqBlack,
      highlightColor: spqLightGrey,
      child: SpeaqTextField(
        isEnabled: false,
        maxLength: maxDescriptionLength,
        controller: _descriptionController,
        label: appLocale.description,
        maxLines: 12,
        newLines: 5,
        icon: const Icon(Icons.format_align_left),
      ),
    );
  }

  Widget _buildWebsiteTextFieldShimmer(AppLocalizations appLocale) {
    return Shimmer.fromColors(
      baseColor: spqBlack,
      highlightColor: spqLightGrey,
      child: SpeaqTextField(
        isEnabled: false,
        maxLength: maxWebsiteLength,
        controller: _websiteController,
        label: appLocale.website,
        icon: const Icon(Icons.link),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      Size deviceSize, Profile profile, AppLocalizations appLocale) {
    return SpqAppBar(
      title: Text(
        appLocale.editProfile,
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: TextButton(
        onPressed: _cancel,
        child: Text(
          appLocale.cancel,
          style: const TextStyle(
            color: spqPrimaryBlue,
          ),
        ),
      ),
      leadingWidth: 80,
      actionList: [
        TextButton(
          onPressed: () => _saveProfile(appLocale),
          child: Text(
            appLocale.done,
            style: const TextStyle(
              color: spqPrimaryBlue,
            ),
          ),
        ),
      ],
      preferredSize: deviceSize,
    );
  }

  PreferredSizeWidget _buildLoadingAppBar(
      Size deviceSize, AppLocalizations appLocale) {
    return SpqAppBar(
      title: Text(
        appLocale.editProfile,
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      preferredSize: deviceSize,
      leading: null,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildProfileImage(Profile profile) {
    return Hero(
      tag: 'dash',
      child: BlocBuilder<ResourceBloc, ResourceState>(
        bloc: _resourceBloc,
        builder: (context, state) {
          if (state is ResourceLoaded) {
            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(state.decodedData),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            );
          } else if (profile.profileImageBlurHash.isNotEmpty) {
            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: BlurHashImage(profile.profileImageBlurHash),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            );
          } else {
            return Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: spqPrimaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.add_a_photo,
                  color: spqWhite,
                  size: 38,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFullScreenProfileImage(BuildContext context, String username) {
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
      body: BlocBuilder<ResourceBloc, ResourceState>(
        bloc: _resourceBloc,
        builder: (context, state) {
          if (state is ResourceLoaded) {
            return Container(
              color: spqWhite,
              child: Center(
                child: Hero(
                  tag: 'dash',
                  child: Image(image: MemoryImage(state.decodedData)),
                ),
              ),
            );
          } else {
            return const Text("Error Resource State");
          }
        },
      ),
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _saveProfile(AppLocalizations appLocale) {
    Profile profile = Profile(
      name: _nameController.text,
      username: _usernameController.text,
      description: _descriptionController.text,
      website: _websiteController.text,
    );

    String errorString = _checkIfInputIsValid(profile, appLocale);
    if (errorString.isNotEmpty) {
      final snackBar = SnackBar(
        content: Text(
          "${appLocale.wrongInput} :$errorString",
          textAlign: TextAlign.center,
        ),
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    _profileBloc.add(
      SaveProfile(
        userId: 1,
        profile: profile,
      ),
    );
  }

  String _checkIfInputIsValid(Profile profile, AppLocalizations appLocale) {
    if (profile.name.length > maxNameLength) return appLocale.nameIsToLong;
    if (profile.name.isEmpty) return appLocale.nameIsEmpty;
    if (profile.name.endsWith(" ")) return appLocale.nameEndsWithSpace;

    if (profile.username.length > maxLengthUsername) {
      return appLocale.usernameIsToLong;
    }
    if (profile.username.isEmpty) return appLocale.usernameIsEmpty;
    if (profile.username.endsWith(" ")) return appLocale.usernameEndsWithSpace;

    if (profile.description.length > maxLengthDescription) {
      return appLocale.descriptionIsToLong;
    }
    if (profile.description.endsWith(" ")) {
      return appLocale.descriptionEndsWithSpace;
    }

    if (profile.website.length > maxLengthWebsite) {
      return appLocale.websiteIsToLong;
    }
    if (!profile.website.contains(".") && profile.website.isNotEmpty) {
      return appLocale.websiteHasNoDot;
    }
    if (profile.website.endsWith(" ")) return appLocale.websiteEndsWithSpace;
    return "";
  }

  @override
  void dispose() {
    super.dispose();

    _disposeController();
    _profileBloc.close();
    _resourceBloc.close();
  }

  void _disposeController() {
    _nameController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
  }
}
