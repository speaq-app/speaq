import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/blocs/register_bloc/register_bloc.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:grpc/grpc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isHidden = true;
  double _passwordStrength = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController = TextEditingController();

  final RegisterBloc _registerBloc = RegisterBloc();

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    var deviceSize = MediaQuery.of(context).size;

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            buildTop(context, appLocale),
            buildBottom(context, appLocale, deviceSize),
          ],
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
              hintText: appLocale.username,
              controller: _nameController,
              labelText: appLocale.username,
              onChanged: (value) {},
              icon: Icons.person,
              borderColor: Border.all(color: spqLightBlack),
            ),
          ),
          RoundTextField(
            autofill: const [AutofillHints.newPassword],
            hintText: appLocale.password,
            labelText: _passwordStrength == 0
                ? appLocale.password
                : _passwordStrength <= 2 / 4
                    ? appLocale.passwordMin
                    : _passwordStrength == 3 / 4
                        ? appLocale.passwordReq
                        : appLocale.passwordCorrect,
            isHidden: isHidden,
            controller: _passwordController,
            icon: Icons.lock,
            borderColor: _passwordStrength == 0
                ? Border.all(color: spqLightBlack)
                : _passwordStrength <= 1 / 4
                    ? Border.all(color: spqLightRed)
                    : _passwordStrength == 2 / 4
                        ? Border.all(color: spqLightYellow)
                        : _passwordStrength == 3 / 4
                            ? Border.all(color: spqSecondaryAqua)
                            : Border.all(color: spqLightGreen),
            suffixIcon: _buildVisibility(),
            onChanged: (password) => _onPasswordChanged(password),
          ),
          RoundTextField(
            autofill: const [AutofillHints.password],
            hintText: appLocale.passwordCheck,
            labelText: appLocale.passwordCheck,
            isHidden: true,
            icon: Icons.lock,
            controller: _passwordCheckController,
            borderColor: Border.all(color: spqLightBlack),
            onChanged: (String value) {},
          ),
        ],
      ),
    );
  }

  Widget buildBottom(BuildContext context, AppLocalizations appLocale, Size deviceSize) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            top: 10,
          ),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            bloc: _registerBloc,
            listener: (context, state) {
              if (state is RegisterError) {
                switch (state.code) {
                  case StatusCode.alreadyExists:
                    Flushbar(
                      backgroundColor: spqPrimaryBlue,
                      messageColor: spqWhite,
                      message: appLocale.errorUsernameAlreadyTaken,
                      duration: const Duration(seconds: 5),
                    ).show(context);
                    break;
                  case 1101:
                    Flushbar(
                      backgroundColor: spqPrimaryBlue,
                      messageColor: spqWhite,
                      message: appLocale.errorUsernameAlreadyTaken,
                      duration: const Duration(seconds: 5),
                    ).show(context);
                    break;
                  case 1103:
                    Flushbar(
                      backgroundColor: spqPrimaryBlue,
                      messageColor: spqWhite,
                      message: appLocale.errorUsernameAlreadyTaken,
                      duration: const Duration(seconds: 5),
                    ).show(context);
                    break;

                }
              } else if (state is RegisterSuccess) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is RegisterLoading) {
                return const CircularProgressIndicator();
              }

              return SpeaqButton(
                loginText: appLocale.register,
                onPressed: _onRegister,
              );
            },
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.askExistingAccount,
          text: appLocale.login,
          press: () {
            Navigator.pop(context);
          },
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          child: Divider(
            color: spqBlack,
            thickness: 0.75,
          ),
        ),
        SpeaqPageForwarding(
          hintText: appLocale.guestText,
          text: appLocale.guest,
          press: () {
            Navigator.popAndPushNamed(context, "base");
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposeController();
    _registerBloc.close();
  }

  void _disposeController() {
    _passwordController.dispose();
    _passwordCheckController.dispose();
    _nameController.dispose();
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

  _onPasswordChanged(String password) {
    RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    String _password = password;
    if (_password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        _passwordStrength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        _passwordStrength = 2 / 4;
      });
    } else {
      if (passValid.hasMatch(_password)) {
        setState(() {
          _passwordStrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          _passwordStrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  _onRegister() {
    var username = _nameController.text;
    var password = _passwordController.text;

    _registerBloc.add(RegisterUser(
      username: username,
      password: password,
    ));
  }
}
