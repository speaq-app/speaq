import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/blocs/resource_bloc/resource_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/speaq_loading_widget.dart';
import 'package:frontend/widgets/speaq_text_field.dart';
import 'package:shimmer/shimmer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileBloc _profileBloc = ProfileBloc();
  final ResourceBloc _resourceBloc = ResourceBloc();

  late String hcImageURL = "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

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
    _profileBloc.add(LoadProfile(
      userId: 1,
      fromCache: false,
    ));
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
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          listener: (context, state) async {
            if (state is ProfileLoaded) {
              var profile = state.profile;
              _nameController.text = profile.name;
              _usernameController.text = profile.username;
              _descriptionController.text = profile.description;
              _websiteController.text = profile.website;
              _resourceBloc.add(LoadResource(resourceId: profile.profileImageResourceId));
            } else if (state is ProfileSaved) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is ProfileSaving) {
              return SpqLoadingWidget(MediaQuery.of(context).size.shortestSide * 0.15);
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
                  child: _buildListViewWithData(context, appLocale, state.profile),
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

  ListView _buildListViewWithData(BuildContext context, AppLocalizations appLocale, Profile profile) {
    return ListView(
      children: [
        Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => _buildFullScreenProfileImage(context, profile.username),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return child;
                })),
            child: _buildProfileImage(profile.profileImageBlurHash),
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
      maxLength: maxLengthName,
      controller: _nameController,
      label: appLocale.name,
      icon: const Icon(Icons.person_outline),
    );
  }

  Widget _buildUsernameTextField(AppLocalizations appLocale) {
    return SpeaqTextField(
      maxLength: maxLengthUsername,
      controller: _usernameController,
      label: appLocale.username,
      icon: const Icon(Icons.alternate_email_rounded),
    );
  }

  Widget _buildDescriptionTextField(AppLocalizations appLocale) {
    return SpeaqTextField(
      maxLength: maxLengthDescription,
      controller: _descriptionController,
      label: appLocale.description,
      maxLines: 12,
      newLines: 5,
      icon: const Icon(Icons.format_align_left),
    );
  }

  Widget _buildWebsiteTextField(AppLocalizations appLocale) {
    return SpeaqTextField(
      maxLength: maxLengthWebsite,
      controller: _websiteController,
      label: appLocale.website,
      icon: const Icon(Icons.link),
    );
  }

  Widget _buildListViewShimmer(BuildContext context, AppLocalizations appLocale) {
    return ListView(
      children: [
        Center(
          child: _buildProfileImageShimmer(hcImageURL),
        ),
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
        maxLength: maxLengthName,
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
        maxLength: maxLengthUsername,
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
        maxLength: maxLengthDescription,
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
        maxLength: maxLengthWebsite,
        controller: _websiteController,
        label: appLocale.website,
        icon: const Icon(Icons.link),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Size deviceSize, Profile profile, AppLocalizations appLocale) {
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

  PreferredSizeWidget _buildLoadingAppBar(Size deviceSize, AppLocalizations appLocale) {
    return SpqAppBar(
      title: Text(
        appLocale.editProfile,
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      preferredSize: deviceSize,
      leading: null,
      isAutomaticallyImplyLeading: false,
    );
  }

  Widget _buildProfileImage(String profileImageBlurHash) {
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
          } else {
            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: BlurHashImage(profileImageBlurHash),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileImageShimmer(String imageURL) {
    return Hero(
      tag: 'dash',
      child: Shimmer.fromColors(
        baseColor: spqLightGrey,
        highlightColor: spqWhite,
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
    Profile _profile = Profile(
      name: _nameController.text,
      username: _usernameController.text,
      description: _descriptionController.text,
      website: _websiteController.text,
    );
    String errorAt = _checkIfInputIsValid(_profile, appLocale);
    if (errorAt.isEmpty) {
      _profileBloc.add(
        SaveProfile(
          userId: 1,
          profile: _profile,
        ),
      );
    } else {
      final snackBar = SnackBar(
          content: Text(
        appLocale.errorSavingEditProfile + errorAt + "!",
        textAlign: TextAlign.center,
      ));
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String _checkIfInputIsValid(Profile profile, AppLocalizations appLocale) {
    if (profile.name.length > maxLengthName || profile.name.isEmpty || profile.name.endsWith(" ") || profile.name.contains("\n") || profile.name.contains("\t")) return appLocale.name;

    if (profile.username.length > maxLengthUsername || profile.username.isEmpty || profile.username.endsWith(" ") || profile.username.contains("\n") || profile.username.contains("\t")) return appLocale.username;

    if (profile.description.length > maxLengthDescription) return appLocale.description;

    if (profile.website.length > maxLengthWebsite || !profile.website.contains(".") || profile.website.endsWith(" ") || profile.website.contains("\n") || profile.website.contains("\t")) return appLocale.website;

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
