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
  bool _isPasswordCorrect = false;

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

  Widget buildTop(BuildContext, AppLocalizations appLocale) => Container(
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
              labelTex: appLocale.password,
              isHidden: isHidden,
              controller: _passwordController,
              icon: Icons.lock,
              borderColor: _isPasswordCorrect
                  ? Border.all(color: Colors.lightGreen)
                  : Border.all(color: Colors.redAccent),
              suffixIcon: buildVisibility(),
              onChanged: (password) => onPasswordChanged(password),
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

  Widget buildBottom(BuildContext context, AppLocalizations appLocale) =>
      Column(
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
          AccountCheck(
            login: false,
            hintRegister: appLocale.registerHint,
            loginText: appLocale.login,
            press: () {
              Navigator.popAndPushNamed(context, "login");
            },
            register: '',
            hintLogin: '',
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
          SpeaqGuestForwarding(
            homeText: appLocale.guestText,
            home: appLocale.guest,
          ),
        ],
      );

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

  InkWell buildVisibility() {
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

  onPasswordChanged(String password) {
    final number = RegExp(r'[0-9]');
    final capitalize = RegExp(r'[A-Z]');

    setState(() {
      _isPasswordCorrect = false;
      if (password.length >= 8 &&
          number.hasMatch(password) &&
          capitalize.hasMatch(password)) {
        _isPasswordCorrect = true;
      }
    });
  }
}
