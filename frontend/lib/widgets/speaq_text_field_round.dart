import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

class RoundInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person_outline,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}