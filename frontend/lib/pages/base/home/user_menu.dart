import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/blocs/settings_bloc/settings_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({Key? key}) : super(key: key);

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  final SettingsBloc _settingsBloc = SettingsBloc();

  String userName = "@hhn";

  String name = "Informatics";

  String follower = "234";

  String following = "690";

  String image =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context, appLocale),
              buildMenu(context, appLocale),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, AppLocalizations appLocale) {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 24,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              userName,
              style: const TextStyle(fontSize: 15),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, 'follow'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Row(
                      children: [
                        Text(
                          following,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            appLocale.following,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Text(
                            follower,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          appLocale.follower,
                          style: const TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenu(BuildContext context, AppLocalizations appLocale) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(appLocale.profile),
          onTap: () {
            Navigator.popAndPushNamed(context, "profile");
          },
        ),
        ListTile(
          leading: const Icon(Icons.qr_code_2),
          title: Text(appLocale.qrCode),
          onTap: () {
            Navigator.popAndPushNamed(context, "qr_ode");
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: Text(appLocale.bookmarks),
          onTap: () {
            Navigator.popAndPushNamed(context, "bookmarks");
          },
        ),
        const Divider(
          color: Colors.black54,
          thickness: 0.75,
        ),
        ListTile(
          title: Text(appLocale.settingsandprivacy),
          onTap: () {
            Navigator.popAndPushNamed(context, "settings");
          },
        ),
        BlocConsumer<SettingsBloc, SettingsState>(
          bloc: _settingsBloc,
          listener: (context, state) async {
            if (state is ImprintURLLoaded) {
              await launchUrl(state.imprintURL);
            }
          },
          builder: (context, state) {
            if (state is LoadingImprintURL) {
              return const ListTile(
                title: Text(appLocale.imprint),
                trailing: CircularProgressIndicator(),
              );
            }

            return ListTile(
              title: Text(appLocale.imprint),
              onTap: () {
                _settingsBloc.add(LoadImprintURL());
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }
}
