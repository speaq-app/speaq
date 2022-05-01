import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/utils/speaq_styles.dart';
import 'package:frontend/widgets/all_widgets.dart';

import '../../../utils/speaq_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String langKey = "pages.start.login.";

  final String name = "Email/Username";
  final String password = "password";
  final String forgot = "Forgot Password";
  final String loginText = "Login";
  final String registerText = "You don't have an Account?";
  final String register = "Register";
  final String hinweisLogin = "Du hast noch keinen Account?";
  final String hinweisRegister = "Besitzt du bereits einen Account?";
  final String homeText = "Du möchtest als Gast beitreten?";
  final String home = "Gast";

  final TextEditingController _usernameTEC = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildTop(context), buildBottom(context)],
          ),
        ),
      );

  Widget buildTop(BuildContext context) => Container(
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
            padding: const EdgeInsets.only(top: 100, bottom: 10),
            child: RoundInputField(
              hintText: name,
              onChanged: (value) {},
            ),
          ),
          RoundPasswordField(
            password: password,
            onChanged: (String value) {}
          )
        ],
      ));

  Widget buildBottom(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: spqPrimaryBlue,
                    padding: const EdgeInsets.all(15.0),
                    fixedSize: const Size(200, 50),
                    primary: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(29))),
                  ),
                  onPressed: () {Navigator.popAndPushNamed(context, "base");},
                  child: Text(loginText)),
            ),
            AccountCheck(
              hinweisLogin: hinweisLogin,
              hinweisRegister: hinweisRegister,
              register: register,
              loginText: loginText,
              press: () {Navigator.popAndPushNamed(context, "register");},
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
                  child: Text(homeText, style: const TextStyle(fontSize: 10)),
                ),
                GestureDetector(
                    onTap: () {Navigator.popAndPushNamed(context, "base");},
                    child: Text(
                      home,
                      style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ],
        ),
      );

  void _loginUser() async {
    log(_usernameTEC.text);
    //_checkUser()
    Navigator.popAndPushNamed(context, "base");
  }
}

//void _checkUser()
