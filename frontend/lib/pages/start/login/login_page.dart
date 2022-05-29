import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserService _userService = GRPCUserService();
  final AuthenticationBloc _authenticationBloc = AuthenticationBloc();


  bool isHidden = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
      child: SafeArea(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          bloc: _authenticationBloc,
          listener: (context, state){

          },
          builder: (context, state){
if(state is )
          }


        ),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            buildTop(context, appLocale),
            buildBottom(context, appLocale),
          ],
        ),
      ),
    );
  }
*/

  Widget buildTop(BuildContext context, AppLocalizations appLocale) {
    return Container(
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
              autofill: const [AutofillHints.name],
              icon: Icons.person,
              hintText: appLocale.username,
              onChanged: (value) {},
              controller: _usernameController,
              labelTex: appLocale.username,
              borderColor: Border.all(color: spqBlack),
            ),
          ),
          RoundTextField(
            autofill: const [AutofillHints.password],
            icon: Icons.lock,
            hintText: appLocale.password,
            isHidden: isHidden,
            labelTex: appLocale.password,
            controller: _passwordController,
            suffixIcon: _buildVisibility(),
            onChanged: (String value) {},
            borderColor: Border.all(color: spqBlack),
          ),
          GestureDetector(
            onTap: () {
              print("Forgot password");
            },
            child: Text(
              appLocale.forgotPassword,
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
  }

  Widget buildBottom(BuildContext context, AppLocalizations appLocale) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            top: 10,
          ),
          child: SpeaqButton(
            loginText: appLocale.login,
            onPressed: () async {
              //Navigator.popAndPushNamed(context, "base");
              //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
              print("3. sdjklhfujkhsjklgfhsjklrhgjsh");
              print("username: " + _usernameController.text);
              print("password: " + _passwordController.text);

              LoginResponse loginResponse = await _userService.login( username: _usernameController.text, password: _passwordController.text);

              if(loginResponse.token != null && loginResponse.token.isNotEmpty) {
                print(loginResponse.token);
                Navigator.popAndPushNamed(context, "base");

              } else {
                print("UFF!");
              }

            },
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.registerText,
          text: appLocale.register,
          press: () {
            print("2. sikugfzuishgdfuis");
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Divider(
            color: spqBlack,
            thickness: 0.75,
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.guestText,
          text: appLocale.guest,
          press: () {
            print("1. jbnklhskl");
            //Navigator.popAndPushNamed(context, "base");
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
  }

  void _disposeController() {
    _passwordController.dispose();
    _usernameController.dispose();
  }

  InkWell _buildVisibility() {
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
              color: spqBlack,
            )
          : const Icon(
              Icons.visibility_off,
              color: spqBlack,
            ),
    );
  }
}
