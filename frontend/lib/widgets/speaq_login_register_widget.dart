import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SpeaqButton extends StatelessWidget {
  const SpeaqButton({
    Key? key,
    required this.loginText,
    required this.onPressed,
  }) : super(key: key);

  final String loginText;
  final Function onPressed;

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
        onPressed: () => onPressed(),
        child: Text(loginText));
  }
}

class SpeaqPageForwarding extends StatelessWidget {
  final Function press;

  const SpeaqPageForwarding({
    Key? key,
    required this.press,
    required this.hintText,
    required this.text,
  }) : super(key: key);

  final String text;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            hintText,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => press(),
          child: Text(
            text,
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
