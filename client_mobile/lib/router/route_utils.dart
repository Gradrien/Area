/// An enumeration of different pages in the application.
enum AppPage {
  /// The splash screen page.
  splash,
  /// The register page.
  register,
  /// The login page.
  login,
  /// The home page.
  home,
  /// The error page.
  error,
  /// The profile page.
  profile
}

/// An extension on the [AppPage] enumeration to provide various methods for generating route paths, names, and titles.
extension AppPageExtension on AppPage {
  /// Returns the route path corresponding to the page.
  String get toPath {
    switch (this) {
      case AppPage.home:
        return "/";
      case AppPage.login:
        return "/login";
      case AppPage.splash:
        return "/splash";
      case AppPage.error:
        return "/error";
      case AppPage.register:
        return "/register";
      case AppPage.profile:
        return "/profile";
      default:
        return "/";
    }
  }

  /// Returns the route name corresponding to the page.
  String get toName {
    switch (this) {
      case AppPage.home:
        return "HOME";
      case AppPage.login:
        return "LOGIN";
      case AppPage.splash:
        return "SPLASH";
      case AppPage.error:
        return "ERROR";
      case AppPage.register:
        return "REGISTER";
      case AppPage.profile:
        return "PROFILE";
      default:
        return "HOME";
    }
  }

  /// Returns the title for the page, which can be displayed in the UI.
  String get toTitle {
    switch (this) {
      case AppPage.home:
        return "Area";
      case AppPage.login:
        return "Log In";
      case AppPage.splash:
        return "Splash";
      case AppPage.error:
        return "Error";
      case AppPage.register:
        return "Register";
      case AppPage.profile:
        return "Profile";
      default:
        return "Area";
    }
  }
}