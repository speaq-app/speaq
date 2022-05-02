import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/utils/speaq_styles.dart';
import 'package:frontend/widgets/all_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String langKey = "pages.start.register.";

  final String name = "username";
  final String password = "password";
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
              child: RoundInputField(
                hintText: name,
                onChanged: (value) {},
                controller: _nameController,
              ),
            ),
            RoundPasswordField(
              password: password,
              isHidden: isHidden,
              controller: _passwordController,
              onChanged: (String value) {},
            ),
            RoundPasswordField(
              password: passwordCheck,
              isHidden: isHidden,
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
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: spqPrimaryBlue,
                  padding: const EdgeInsets.all(15.0),
                  fixedSize: const Size(200, 50),
                  primary: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(29),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, "base");
                },
                child: Text(register)),
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
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Divider(
              color: Colors.black54,
              thickness: 0.75,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  homeText,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, "base");
                },
                child: Text(
                  home,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
    _passwordCheckController;
    _nameController.dispose();
  }
}
