import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/widgets/all_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String langKey = "pages.start.register.";

  final String name = "Username";
  final String password = "Password";
  final String passwordCheck = "repeat password";
  final String returnPassword = "return password";
  final String register = "Register";
  final String login = "login";
  final String registerText = "You dont't have an Account?";
  final String hinweisRegister = "Besitzt du bereits einen Account?";
  final String homeText = "Du möchtest als Gast beitreten?";
  final String home = "Gast";
  bool isHidden = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

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

  Widget buildTop(BuildContext) => Container(
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
                hintText: name,
                controller: _nameController,
                labelTex: name,
                onChanged: (value) {},
                icon: Icons.person,
              ),
            ),
            RoundTextField(
              hintText: password,
              labelTex: password,
              isHidden: isHidden,
              controller: _passwordController,
              icon: Icons.lock,
              suffixIcon: buildVisibility(),
              onChanged: (String value) {},
            ),
            RoundTextField(
              hintText: passwordCheck,
              labelTex: passwordCheck,
              isHidden: isHidden,
              icon: Icons.lock,
              controller: _passwordCheckController,
              onChanged: (String value) {},
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
            child: SpeaqButton(loginText: register),
          ),
          AccountCheck(
            login: false,
            hinweisRegister: hinweisRegister,
            loginText: login,
            press: () {
              Navigator.popAndPushNamed(context, "login");
            },
            register: '',
            hinweisLogin: '',
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
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
    _passwordCheckController.dispose();
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
        Icons.visibility_off,
        color: Colors.black,
      )
          : const Icon(
        Icons.visibility,
        color: Colors.black,
      ),
    );
  }
}
