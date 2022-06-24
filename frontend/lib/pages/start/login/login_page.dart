import 'package:another_flushbar/flushbar.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:grpc/grpc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      child: ColorfulSafeArea(
        color: spqWhite,
        child: Scaffold(
          body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              bloc: _authenticationBloc,
              listener: (context, state) {
                if (state is LogInSuccess) {
                  Navigator.pushNamed(context, "base", arguments: {"userID": state.userID, "token": state.token});
                } else if (state is LoginError) {
                  String message;
                  switch (state.code) {
                    case StatusCode.unauthenticated:
                      message = appLocale.wrongPassword;
                      break;
                    case StatusCode.notFound:
                      message = appLocale.userNotFound;
                      break;
                    case StatusCode.unknown:
                      message = appLocale.wrongPassword;
                      break;
                    default:
                      message = appLocale.unknownError;
                  }
                  Flushbar(
                    backgroundColor: spqPrimaryBlue,
                    messageColor: spqWhite,
                    message: message,
                    duration: const Duration(seconds: 5),
                  ).show(context);
                }
              },
              builder: (context, state) {
                if (state is TryLoggingIn) {
                  return SpqLoadingWidget(deviceSize.shortestSide * 0.15);
                } else if (state is LoginError) {
                  return ListView(
                    children: <Widget>[
                      buildTop(context, appLocale),
                      buildBottom(context, appLocale),
                    ],
                  );
                } else if (state is LogInSuccess) {
                  return const SizedBox.shrink();
                } else {
                  return ListView(
                    children: <Widget>[
                      buildTop(context, appLocale),
                      buildBottom(context, appLocale),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }

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
              labelText: appLocale.username,
              borderColor: Border.all(color: spqLightBlack),
            ),
          ),
          RoundTextField(
            autofill: const [AutofillHints.password],
            icon: Icons.lock,
            hintText: appLocale.password,
            isHidden: isHidden,
            labelText: appLocale.password,
            controller: _passwordController,
            suffixIcon: _buildVisibility(),
            onChanged: (value) {},
            borderColor: Border.all(color: spqLightBlack),
          ),
          GestureDetector(
            onTap: () {
              //TODO - Implement forgot password
              //print("Forgot password");
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
            onPressed: () {
              _authenticationBloc.add(LoggingIn(username: _usernameController.text, password: _passwordController.text));
            },
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.registerText,
          text: appLocale.register,
          press: () {
            Navigator.pushNamed(context, "register");
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Divider(
            color: spqBlack,
            thickness: 0.75,
          ),
        ),
//TODO - Guest Login
/*
        SpeaqPageForwarding(
          hintText: appLocale.guestText,
          text: appLocale.guest,
          press: () {
            print("1. jbnklhskl");
            //Navigator.popAndPushNamed(context, "base");
          },
        ),
*/
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
    _authenticationBloc.close();
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
