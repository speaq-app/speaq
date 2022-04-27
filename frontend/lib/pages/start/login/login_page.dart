import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/speaq_text_field_round.dart';

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
  final String login = "Login";
  final String registerText = "You don't have an Account?";
  final String register = "Register";

  final TextEditingController _usernameTEC = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildTop(context),
            buildBottom(context)],
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
          RoundInputField(
            hintText: name,
            onChanged: (value) {},
          ),
           RoundPasswordField(password: password, onChanged: (String value) {  },)
        ],
      ));

  Widget buildBottom(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            FloatingActionButton(onPressed: (){}, child: Text(login) )
          ],
        ),
      );

  void _loginUser() async {
    log(_usernameTEC.text);
    //_checkUser()
    Navigator.pushNamed(context, "base");
  }
}

class RoundPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundPasswordField({
    Key? key,
    required this.password, required this.onChanged,
  }) : super(key: key);

  final String password;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
       child: TextField(
         obscureText: true,
          onChanged: onChanged,
     decoration:
         InputDecoration(
           hintText: password,
           icon: Icon(Icons.lock, color: Colors.black),
           suffixIcon: Icon(Icons.visibility, color: Colors.black),
         border: InputBorder.none,
         ),
          ));
  }
}

//void _checkUser()
