import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  final Function press;

  const AccountCheck({
    Key? key,
    this.login = true,
    required this.press,
    required this.hintLogin,
    required this.hintRegister,
    required this.register,
    required this.loginText,
  }) : super(key: key);

  final String hintLogin;
  final String hintRegister;
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
            login ? hintLogin : hintRegister,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => press(),
          child: Text(
            login ? register : loginText,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
