import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SpeaqButton extends StatelessWidget {
  const SpeaqButton({
    Key? key,
    required this.loginText,
  }) : super(key: key);

  final String loginText;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
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
        child: Text(loginText));
  }
}

class SpeaqGuestForwarding extends StatelessWidget {
  const SpeaqGuestForwarding({
    Key? key,
    required this.homeText,
    required this.home,
  }) : super(key: key);

  final String homeText;
  final String home;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            homeText,
            style: const TextStyle(fontSize: 10),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.popAndPushNamed(context, "base");
          },
          child: Text(
            home,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}