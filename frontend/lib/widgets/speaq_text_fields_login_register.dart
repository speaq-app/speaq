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
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: Colors.black26),
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

class RoundPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isHidden = true;
  final String password;

  const RoundPasswordField({
    Key? key,
    required this.password,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      obscureText: isHidden,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: password,
        icon: const Icon(Icons.lock, color: Colors.black),
        suffixIcon: InkWell(onTap: () {_toggleView();}, child: const Icon(Icons.visibility, color: Colors.black)),
        border: InputBorder.none,
      ),
    ));
  }

  void _toggleView() {

    //isHidden = !isHidden;
  }
}
