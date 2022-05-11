import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            buildTop(context, appLocale),
            buildBottom(context, appLocale),
          ],
        ),
      ),
    );
  }

  Widget buildTop(BuildContext context, AppLocalizations appLocale) {
    return Container(
      padding: const EdgeInsets.only(
        top: 125,
        bottom: 50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            "assets/images/logo/speaq_text_logo.svg",
            height: 75,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: RoundTextField(
              autofill: const [AutofillHints.name],
              icon: Icons.person,
              hintText: appLocale.username,
              onChanged: (value) {},
              controller: _nameController,
              labelTex: appLocale.username,
              borderColor: Border.all(color: Colors.black26),
            ),
          ),
          RoundTextField(
            autofill: const [AutofillHints.password],
            icon: Icons.lock,
            hintText: appLocale.password,
            isHidden: isHidden,
            labelTex: appLocale.password,
            controller: _passwordController,
            suffixIcon: _buildVisibility(),
            onChanged: (String value) {},
            borderColor: Border.all(color: Colors.black26),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              appLocale.passwordForgot,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottom(BuildContext context, AppLocalizations appLocale) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            top: 10,
          ),
          child: SpeaqButton(
            loginText: appLocale.login,
            onPressed: () {
              Navigator.popAndPushNamed(context, "base");
            },
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.loginHint,
          text: appLocale.register,
          press: () {
            Navigator.popAndPushNamed(context, "register");
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Divider(
            color: Colors.black54,
            thickness: 0.75,
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.guestText,
          text: appLocale.guest,
          press: () {
            Navigator.popAndPushNamed(context, "base");
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
  }

  void _disposeController() {
    _passwordController.dispose();
    _nameController.dispose();
  }

  InkWell _buildVisibility() {
    return InkWell(
      onTap: () {
        setState(
          () {
            isHidden = !isHidden;
          },
        );
      },
      child: isHidden
          ? const Icon(
              Icons.visibility,
              color: Colors.black,
            )
          : const Icon(
              Icons.visibility_off,
              color: Colors.black,
            ),
    );
  }
}
