import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isHidden = true;
  double _passwordStrength = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

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
              hintText: appLocale.username,
              controller: _nameController,
              labelTex: appLocale.username,
              onChanged: (value) {},
              icon: Icons.person,
              borderColor: Border.all(color: Colors.black26),
            ),
          ),
          RoundTextField(
            autofill: const [AutofillHints.newPassword],
            hintText: appLocale.password,
            labelTex: _passwordStrength == 0
                ? appLocale.password
                : _passwordStrength <= 2 / 4
                    ? appLocale.passwordMin
                    : _passwordStrength == 3 / 4
                        ? appLocale.passwordReq
                        : appLocale.passwordCorrect,
            isHidden: isHidden,
            controller: _passwordController,
            icon: Icons.lock,
            borderColor: _passwordStrength == 0
                ? Border.all(color: Colors.black26)
                : _passwordStrength <= 1 / 4
                    ? Border.all(color: Colors.redAccent)
                    : _passwordStrength == 2 / 4
                        ? Border.all(color: Colors.yellowAccent)
                        : _passwordStrength == 3 / 4
                            ? Border.all(color: Colors.lightBlue)
                            : Border.all(color: Colors.lightGreen),
            suffixIcon: _buildVisibility(),
            onChanged: (password) => _onPasswordChanged(password),
          ),
          RoundTextField(
            autofill: const [AutofillHints.password],
            hintText: appLocale.passwordCheck,
            labelTex: appLocale.passwordCheck,
            isHidden: true,
            icon: Icons.lock,
            controller: _passwordCheckController,
            borderColor: Border.all(color: Colors.black26),
            onChanged: (String value) {},
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
            loginText: appLocale.register,
            onPressed: () {},
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.askExistingAccount,
          text: appLocale.login,
          press: () {
            Navigator.popAndPushNamed(context, "login");
          },
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
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
    _passwordCheckController.dispose();
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

  _onPasswordChanged(String password) {
    RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    String _password = password;
    if (_password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        _passwordStrength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        _passwordStrength = 2 / 4;
      });
    } else {
      if (passValid.hasMatch(_password)) {
        setState(() {
          _passwordStrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          _passwordStrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }
}
