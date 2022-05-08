import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/all_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String name = "Username";
  final String password = "Password";
  final String forgot = "Forgot Password?";
  final String loginText = "Login";
  final String registerText = "You don't have an Account?";
  final String register = "Register";
  final String hinweisLogin = "Du hast noch keinen Account?";
  final String hinweisRegister = "Besitzt du bereits einen Account?";
  final String homeText = "Du möchtest als Gast beitreten?";
  final String home = "Gast";

  bool isHidden = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              buildTop(context),
              buildBottom(context),
            ],
          ),
        ),
      );

  Widget buildTop(BuildContext context) => Container(
        padding: const EdgeInsets.only(
          top: 125,
          bottom: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/images/logo/speaq_text_logo.svg",
              height: 75,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: RoundTextField(
                icon: Icons.person,
                hintText: name,
                onChanged: (value) {},
                controller: _nameController,
                labelTex: name,
                borderColor: Border.all(color: Colors.black26),
              ),
            ),
            RoundTextField(
              icon: Icons.lock,
              hintText: password,
              isHidden: isHidden,
              labelTex: password,
              controller: _passwordController,
              suffixIcon: buildVisibility(),
              onChanged: (String value) {},
              borderColor: Border.all(color: Colors.black26),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                forgot,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildBottom(BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
              top: 10,
            ),
            child: SpeaqButton(loginText: loginText),
          ),
          AccountCheck(
            hinweisLogin: hinweisLogin,
            hinweisRegister: hinweisRegister,
            register: register,
            loginText: loginText,
            press: () {
              Navigator.popAndPushNamed(context, "register");
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Divider(
              color: Colors.black54,
              thickness: 0.75,
            ),
          ),
          SpeaqGuestForwarding(
            homeText: homeText,
            home: home,
          ),
        ],
      );

  @override
  void dispose() {
    super.dispose();
    _disposeController();
  }

  void _disposeController() {
    _passwordController.dispose();
    _nameController.dispose();
  }

  InkWell buildVisibility() {
    return InkWell(
      onTap: () {
        setState(
          () {
            isHidden = !isHidden;
          },
        );
      },
      child: isHidden
          ? const Icon(
              Icons.visibility,
              color: Colors.black,
            )
          : const Icon(
              Icons.visibility_off,
              color: Colors.black,
            ),
    );
  }
}
