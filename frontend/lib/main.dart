import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/model/user.dart';
import 'package:frontend/blocs/profile_bloc/profile_bloc.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/utils/backend_utils.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'widgets/all_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ConnectionUtilSingleton connectionStatus =
      ConnectionUtilSingleton.getInstance();
  connectionStatus.initialize();

  await initHive();
  await TokenUtils.init();
  await BackendUtils.init();

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
          locale: localeProvider.locale,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _profileBloc = ProfileBloc();

  @override
  void initState() {
    super.initState();

    _profileBloc.add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) async {
        if (state is ProfileError) {
          await TokenUtils.setToken(null);
        }
      },
      builder: (context, state) {
        if (state is ProfileError) {
          return const LoginPage();
        } else if (state is ProfileLoaded) {
          return const BasePage();
        }

        return SpqLoadingWidget(
            MediaQuery.of(context).size.shortestSide * 0.15);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _profileBloc.close();
  }
}
