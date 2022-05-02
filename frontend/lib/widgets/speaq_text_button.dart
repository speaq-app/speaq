import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';

class SpqTextbutton extends StatelessWidget {
  final void Function() onPressed;
  final String name;
  final TextStyle style;
  const SpqTextbutton({
    Key? key,
    required this.onPressed, required this.name, required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child:  Text(
        name,
        style: style,
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
