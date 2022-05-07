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
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: Colors.black26),
      ),
      child: child,
    );
  }
}

class RoundTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isHidden;
  final String? hintText;
  final String? labelTex;
  final String? errorText;
  final Widget? suffixIcon;
  final IconData? icon;
  final TextEditingController controller;

  const RoundTextField({
    Key? key,
    this.hintText,
    this.labelTex,
    this.suffixIcon,
    this.errorText,
    this.isHidden = true,
    required this.controller,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: isHidden,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelTex,
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          errorText: errorText,
          icon: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
