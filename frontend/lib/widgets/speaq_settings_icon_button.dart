import 'package:flutter/material.dart';

class SpqSettingsIconButton extends StatelessWidget {
  final Function() onPressed;

  const SpqSettingsIconButton({
    Key? key, required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      color: Colors.blue,
      iconSize: 25,
      onPressed: onPressed,
    );
  }
}
