import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  final Function press;

  const AccountCheck({
    Key? key,
    this.login = true,
    required this.press,
    required this.hinweisLogin,
    required this.hinweisRegister,
    required this.register,
    required this.loginText,
  }) : super(key: key);

  final String hinweisLogin;
  final String hinweisRegister;
  final String register;
  final String loginText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            login ? hinweisLogin : hinweisRegister,
            style: const TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
        GestureDetector(
          onTap: () => press(),
          child: Text(
            login ? register : loginText,
            style: const TextStyle(
                fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
