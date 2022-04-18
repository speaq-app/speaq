import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:frontend/utils/all_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String langKey = "pages.start.login.";

  final TextEditingController _usernameTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: spqWhite,
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                    ),
                    I18nText(
                      langKey + "login",
                      child: Text(
                        "",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                TextField(
                  controller: _usernameTEC,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  decoration: InputDecoration(
                    labelText: FlutterI18n.translate(context, globalLangKey + "username"),
                    labelStyle: TextStyle(
                      color: spqPrimaryBlue,
                      fontSize: 25,
                    ),
                    filled: true,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ButtonTheme(
                  child: ElevatedButton(
                    child: I18nText(langKey + "login"),
                    onPressed: _loginUser,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginUser() {
    log(_usernameTEC.text);
    //_checkUser()
    Navigator.pushNamed(context, "base");
  }
}

//void _checkUser()
