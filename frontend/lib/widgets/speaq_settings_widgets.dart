import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:settings_ui/settings_ui.dart';

class SpqNavigationSettingsTile extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Widget? trailingIcon;

  const SpqNavigationSettingsTile({
    Key? key,
    required this.text,
    this.trailingIcon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsTile.navigation(
      trailing: trailingIcon ?? Icon(Icons.adaptive.arrow_forward),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onPressed: (context) => onPressed,
    );
  }
}

/// Settings elements for [SettingsPage].
class SpqPopUpSettingsTile extends StatelessWidget {
  final Function()? onPressed;
  final String tileText;
  final String popupMessage;
  final Widget? trailingIcon;

  final String actionButtonText;

  final Color? actionButtonColor;

  const SpqPopUpSettingsTile({
    Key? key,
    required this.tileText,
    this.trailingIcon,
    this.onPressed,
    this.actionButtonColor = spqBlack,
    required this.popupMessage,
    required this.actionButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return SettingsTile.navigation(
      trailing: Icon(Icons.adaptive.arrow_forward),
      title: Text(tileText,
          style: TextStyle(fontSize: 15, color: actionButtonColor)
      ),
      onPressed: (context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(popupMessage),
          actions: [
            TextButton(
                child: Text(
                  actionButtonText,
                  style: TextStyle(color: actionButtonColor),
                ),
                onPressed: () => logOut(context)
            ),
            TextButton(
                child: Text(appLocale.cancel),
                onPressed: () => Navigator.pop(context)
            ),
          ],
        ),
      ),
    );
  }
}

class SpqSwitchSettingsTile extends StatelessWidget {
  const SpqSwitchSettingsTile({
    Key? key,
    required this.value,
    required this.tileText,
    this.onToggle,
  }) : super(key: key);

  final String tileText;
  final bool value;
  final Function(dynamic)? onToggle;

  @override
  Widget build(BuildContext context) {
    return SettingsTile.switchTile(
      title: Text(tileText, style: const TextStyle(fontSize: 15)),
      initialValue: value,
      onToggle: (value) => onToggle,
    );
  }
}
