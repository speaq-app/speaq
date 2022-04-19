import 'dart:developer';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          color: spqWhite,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              Text(
                appLocale.login,
                style: TextStyle(fontSize: 40),
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
                  labelText:  appLocale.username,
                  labelStyle: TextStyle(
                    color: spqPrimaryBlue,
                    fontSize: 25,
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ButtonTheme(
                child: ElevatedButton(
                  child: Text(appLocale.login),
                  onPressed: _loginUser,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    log(_usernameTEC.text);
    //_checkUser()
    Navigator.pushNamed(context, "base");
  }
}

//void _checkUser()
