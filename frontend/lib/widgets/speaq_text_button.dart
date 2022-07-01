import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';

class SpqTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String name;
  final TextStyle textStyle;
  final Color borderColor;
  final Color buttonPrimary;

  const SpqTextButton({
    Key? key,
    required this.onPressed,
    required this.name,
    required this.textStyle,
    this.borderColor = spqPrimaryBlue,
    this.buttonPrimary = spqWhite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      child: Text(
        name,
        style: textStyle,
      ),
    );
  }
}
