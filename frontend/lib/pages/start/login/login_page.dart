import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

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
            child: RoundInputField(
              hintText: appLocale.username,
              onChanged: (value) {},
              controller: _nameController,
            ),
          ),
          RoundPasswordField(
            password: appLocale.password,
            isHidden: isHidden,
            controller: _passwordController,
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
              child: isHidden
                  ? const Icon(
                      Icons.visibility_off,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.visibility,
                      color: Colors.black,
                    ),
            ),
            onChanged: (String value) {},
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              appLocale.forgotPassword,
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
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: spqPrimaryBlue,
                padding: const EdgeInsets.all(15.0),
                fixedSize: const Size(200, 50),
                primary: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(29),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.popAndPushNamed(context, "base");
              },
              child: Text(appLocale.login)),
        ),
        AccountCheck(
          hinweisLogin: appLocale.registerText,
          hinweisRegister: appLocale.askExistingAccount,
          register: appLocale.register,
          loginText: appLocale.login,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                appLocale.guestText,
                style: const TextStyle(fontSize: 10),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.popAndPushNamed(context, "base");
              },
              child: Text(
                appLocale.guest,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
}
