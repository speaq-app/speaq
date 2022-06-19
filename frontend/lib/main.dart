import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pb.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'widgets/all_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ConnectionUtilSingleton connectionStatus =
      ConnectionUtilSingleton.getInstance();
  connectionStatus.initialize();

  await initHive();

  await Settings.init(cacheProvider: SharePreferenceCache());

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarColor: Colors.transparent),
  );

  runApp(const Speaq());
}

initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileAdapter());
  await Hive.openBox<Profile>("profile");
  Hive.registerAdapter(ResourceAdapter());
  await Hive.openBox<Resource>("resource");
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>("user");
}

class Speaq extends StatelessWidget {
  const Speaq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final localeProvider =
            Provider.of<LocaleProvider>(context, listen: true);

        return MaterialApp(
          title: 'Speaq',
          theme: spqLightTheme,
          darkTheme: spqDarkTheme,
          themeMode: ThemeMode.system,
          initialRoute: 'main',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: LocaleProvider.allSupportedLocales,
          locale: Locale('de'),
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}

class MainApp extends StatelessWidget {
  final UserService _userService = CacheUserService(GRPCUserService());

  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: verifyToken("Token aus Cache laden!!!!!!!!"),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const LoginPage();
        } else if (snapshot.hasData) {
          if (snapshot.data!) {
            return Text("SHEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEESH");
          } else {
            return const LoginPage();
          }
        } else {
          return SpqLoadingWidget(
              MediaQuery.of(context).size.shortestSide * 0.15);
        }
      },
    );
  }
}

Future<bool> verifyToken(String token) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => false,
  );
}
