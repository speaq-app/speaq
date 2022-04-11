import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/all_pages_export.dart';

import 'package:frontend/utils/all_utils.dart';

import 'widgets/all_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ConnectionUtilSingleton connectionStatus = ConnectionUtilSingleton.getInstance();
  connectionStatus.initialize();

  runApp(const Speaq());
}

class Speaq extends StatelessWidget {
  const Speaq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speaq',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(foregroundColor: spqBlack, backgroundColor: spqWhite),
          scaffoldBackgroundColor: spqWhite,
          backgroundColor: spqBackgroundGrey,
          bottomAppBarColor: spqWhite,

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: spqWhite, selectedItemColor: spqPrimaryBlue, unselectedItemColor: spqDarkGrey),
          dialogBackgroundColor: spqWhite,
          primaryColor: spqPrimaryBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          errorColor: spqErrorRed,
          shadowColor: spqLightGreyTranslucent,
          //MOCKUP-SCHRIFTART (POPPINS) ALS STANDARDFONT
          textTheme: spqTextTheme),
      initialRoute: 'main',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: verifyIDToken(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const LoginPage();
        } else if (snapshot.hasData) {
          if (snapshot.data!) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        } else {
          return SpqLoadingWidget(MediaQuery.of(context).size.shortestSide * 0.15);
        }
      },
    );
  }
}

Future<bool> verifyIDToken() {
  return Future.delayed(const Duration(seconds: 3), () => false);
}

