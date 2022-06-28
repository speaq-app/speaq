import 'package:another_flushbar/flushbar.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/blocs/login_bloc/login_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:grpc/grpc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBloc _loginBloc = LoginBloc();

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
          body: BlocConsumer<LoginBloc, LoginState>(
              bloc: _loginBloc,
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushNamed(context, "base", arguments: 0);
                } else if (state is LoginError) {
                  String message;
                  switch (state.code) {
                    case StatusCode.invalidArgument:
                      message = appLocale.wrongPassword;
                      break;
                    case StatusCode.notFound:
                      message = appLocale.userNotFound;
                      break;
                    case StatusCode.unauthenticated:
                      message = appLocale.noTokenGenerated;
                      break;
                    case StatusCode.unknown:
                      message = appLocale.unknownError;
                      break;
                    default:
                      message = appLocale.unknownError;
                  }
                  Flushbar(
                    messageText: Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: spqPrimaryBlue,
                    messageColor: spqWhite,
                    duration: const Duration(seconds: 5),
                  ).show(context);
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return SpqLoadingWidget(deviceSize.shortestSide * 0.15);
                } else if (state is LoginError) {
                  return ListView(
                    children: <Widget>[
                      _buildTop(context, appLocale),
                      _buildBottom(context, appLocale),
                    ],
                  );
                } else if (state is LoginSuccess) {
                  return const SizedBox.shrink();
                } else {
                  return ListView(
                    children: <Widget>[
                      _buildTop(context, appLocale),
                      _buildBottom(context, appLocale),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }

  /// Creates the layout for entering [name] and [password] for logging in the user.
  Widget _buildTop(BuildContext context, AppLocalizations appLocale) {
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
              // TODO - Implement forgot password
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

  /// Creates the bottom part of the page with a user interface.
  Widget _buildBottom(BuildContext context, AppLocalizations appLocale) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            top: 10,
          ),
          child: SpeaqButton(
            loginText: appLocale.login,
            onPressed: () => _login(),
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
        //TODO - Login as a guest
      ],
    );
  }

  _login() {
    _loginBloc.add(
      Login(username: _usernameController.text, password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
    _loginBloc.close();
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
