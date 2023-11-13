import 'package:client_mobile/router/route_utils.dart';
import 'package:client_mobile/views/error_view.dart';
import 'package:client_mobile/views/login_view.dart';
import 'package:client_mobile/views/register_view.dart';
import 'package:client_mobile/views/splash_view.dart';
import 'package:go_router/go_router.dart';
import '../nav/nav.dart';
import '../services/app_service.dart';

/// A class that defines the application's routing configuration using the GoRouter package.
class AppRouter {
  /// The [AppService] instance.
  late final AppService appService;

  /// Constructor for the [AppRouter] class.
  /// 
  /// - `appService`: The application's service instance
  AppRouter(this.appService);
  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    initialLocation: AppPage.home.toPath,
    routes: <GoRoute>[
      GoRoute(
        path: AppPage.home.toPath,
        name: AppPage.home.toName,
        builder: (context, state) => const Nav(),
      ),
      GoRoute(
        path: AppPage.splash.toPath,
        name: AppPage.splash.toName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppPage.login.toPath,
        name: AppPage.login.toName,
        builder: (context, state) => LoginForm(),
      ),
      GoRoute(
        path: AppPage.register.toPath,
        name: AppPage.register.toName,
        builder: (context, state) => RegisterForm(),
      ),
      GoRoute(
        path: AppPage.error.toPath,
        name: AppPage.error.toName,
        builder: (context, state) => ErrorView(error: state.extra.toString()),
      ),
    ],
    errorBuilder: (context, state) => ErrorView(error: state.error.toString()),
    redirect: (context, state) {
      final loginLocation = state.namedLocation(AppPage.login.toName);
      final homeLocation = state.namedLocation(AppPage.home.toName);
      final splashLocation = state.namedLocation(AppPage.splash.toName);
      final registerLocation = state.namedLocation(AppPage.register.toName);

      final isLogedIn = appService.loginState;
      final isInitialized = appService.initialized;

      final isGoingToLogin = state.fullPath == loginLocation;
      final isGoingToInit = state.fullPath == splashLocation;
      final isGoingToRegister = state.fullPath == registerLocation;

      // If not Initialized and not going to Initialized redirect to Splash
      if (!isInitialized && !isGoingToInit) {
        print("splash");
        return splashLocation;
      } else if (isInitialized && !isLogedIn && isGoingToRegister) {
        print("redirect");
        return registerLocation;
      } else if (isInitialized && !isLogedIn && !isGoingToLogin) {
        print("login");
        return loginLocation;
      } else
      if ((isLogedIn && isGoingToLogin) || (isInitialized && isGoingToInit)) {
        // If all the scenarios are cleared but still going to any of that screen redirect to Home
        print("home");
        return homeLocation;
      } else {
        // Else Don't do anything
        print("Aucun cas");
        return null;
      }
    },
  );
}