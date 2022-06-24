import 'package:flutter/material.dart';


class RoundTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isHidden;
  final String? hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final IconData? icon;
  final TextEditingController controller;
  final Widget? border;
  final Border borderColor;
  final Iterable<String>? autofill;

  const RoundTextField({
    Key? key,
    this.hintText,
    this.autofill,
    this.labelText,
    this.suffixIcon,
    this.isHidden = false,
    required this.controller,
    required this.onChanged,
    this.icon,
    this.border,
    required this.borderColor,
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
        border: borderColor,
      ),
      child: TextField(
        controller: controller,
        autofillHints: autofill,
        obscureText: isHidden,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
