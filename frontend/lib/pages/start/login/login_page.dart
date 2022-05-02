import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/utils/speaq_styles.dart';
import 'package:frontend/widgets/all_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String langKey = "pages.start.login.";

  final String name = "Username";
  final String password = "password";
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
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isHidden = !isHidden;
                  });
                },
                child: isHidden
                    ? const Icon(Icons.visibility_off, color: Colors.black)
                    : const Icon(Icons.visibility, color: Colors.black)),
            onChanged: (String value) {},
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              forgot,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ));

  Widget buildBottom(BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: spqPrimaryBlue,
                  padding: const EdgeInsets.all(15.0),
                  fixedSize: const Size(200, 50),
                  primary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(29))),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, "base");
                },
                child: Text(loginText)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(homeText, style: const TextStyle(fontSize: 10)),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, "base");
                  },
                  child: Text(
                    home,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ))
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
    _nameController.dispose();
  }
}
