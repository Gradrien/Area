import 'dart:async';
import 'package:client_mobile/router/app_router.dart';
import 'package:client_mobile/services/app_service.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:client_mobile/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

/// Main class for the Flutter application.
class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  /// Constructor for the [MyApp] class.
  ///
  /// - [sharedPreferences]: Instance of SharedPreferences for managing application preferences.
  const MyApp({
    Key? key,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

/// State class for the [MyApp] application.
class _MyAppState extends State<MyApp> {
  late AppService appService;
  late AuthService authService;
  late AreaService areaService;
  late StreamSubscription<bool> authSubscription;

  @override
  void initState() {
    appService = AppService(widget.sharedPreferences);
    authService = AuthService();
    areaService = AreaService();
    authSubscription = authService.onAuthStateChange.listen(onAuthStateChange);
    super.initState();
  }

  /// Method called when the authentication state changes.
  ///
  /// - [login]: A boolean set the boolean value of the login state.
  void onAuthStateChange(bool login) {
    appService.loginState = login;
  }

  @override
  /// Method called when the application is disposed.
  /// 
  /// - No parameters.
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => appService),
        Provider<AppRouter>(create: (_) => AppRouter(appService)),
        Provider<AuthService>(create: (_) => authService),
        Provider<AreaService>(create: (_) => areaService),
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter =
              Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            theme: ThemeData(fontFamily: 'Poppins'),
            title: "Mingle",
            debugShowCheckedModeBanner: false,
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}
