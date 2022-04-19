import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String langKey = "pages.start.register.";

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Container()));
  }
}
