import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class SpqTextButton extends StatelessWidget {
  final void Function() onPressed;

  const SpqTextButton({Key? key, void function, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text(
        "Edit Profile",
        style: TextStyle(color: spqPrimaryBlue),
      ),
      style: ElevatedButton.styleFrom(
        primary: spqWhite,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(
              color: spqPrimaryBlue,
            )),
      ),
    );
  }
}
