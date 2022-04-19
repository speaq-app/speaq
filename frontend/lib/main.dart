import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:provider/provider.dart';
import 'widgets/all_widgets.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ConnectionUtilSingleton connectionStatus = ConnectionUtilSingleton.getInstance();
  connectionStatus.initialize();

  await Settings.init(cacheProvider: SharePreferenceCache());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent, systemStatusBarContrastEnforced: true, systemNavigationBarColor: Colors.transparent));

  runApp(const Speaq());
}

class Speaq extends StatelessWidget {
  const Speaq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final localeProvider = Provider.of<LocaleProvider>(context, listen: true);

        return MaterialApp(
          title: 'Speaq',
          theme: spqLightTheme,
          darkTheme: spqDarkTheme,
          themeMode: ThemeMode.system,
          initialRoute: 'main',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: LocaleProvider.allSupportedLocales,
          locale: localeProvider.locale,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
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
