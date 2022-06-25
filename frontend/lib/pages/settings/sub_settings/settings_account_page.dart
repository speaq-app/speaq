import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/utils/all_utils.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: Text(
            appLocale.account,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          preferredSize: deviceSize,
        ),
        body: Stack(children: [
          SettingsList(
            sections: [
              SpqSettingsSection(
                tiles: [
                  const SizedBox(
                    height: 20,
                  ),
                  SpqNavigationSettingsTile(text: appLocale.accountInformation),
                  SpqNavigationSettingsTile(text: appLocale.changePassword),
                  //Account abmelden
                  SpqPopUpSettingsTile(
                    tileText: appLocale.logout,
                    actionButtonText: appLocale.logout,
                    popupMessage: appLocale.askLogoutAccount,
                    actionButtonColor: spqWarningOrange,
                  ),
                  //Account löschen
                  SpqPopUpSettingsTile(
                    tileText: appLocale.deleteAccount,
                    actionButtonText: appLocale.delete,
                    popupMessage: appLocale.askDeleteAccount,
                    actionButtonColor: spqErrorRed,
                  ),
                ],
              ),
            ],
          ),
          //Logo
          Positioned(
            bottom: 20,
            height: deviceSize.height * 0.1,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildLogoPictures(deviceSize)),
          )
        ]),
      ),
    );
  }

  Widget _buildLogoPictures(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      child: SvgPicture.asset("assets/images/logo/speaq_text_logo.svg",
          height: deviceSize.height * 0.05, width: deviceSize.width * 0.3),
    );
  }
}
