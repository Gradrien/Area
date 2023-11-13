import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
String LOGIN_KEY = dotenv.env["LOGIN_KEY"]!;

/// A service for managing the app state.
class AppService with ChangeNotifier {
  /// The shared preferences instance.
  late final SharedPreferences sharedPreferences;
  /// The login state.
  bool _loginState = false;
  /// The initialized state.
  bool _initialized = false;

  /// Constructor for the [AppService] class.
  /// 
  /// - `sharedPreferences`: The shared preferences instance.
  AppService(this.sharedPreferences);

  bool get loginState => _loginState;
  bool get initialized => _initialized;

  /// Sets the login state.
  set loginState(bool state) {
    sharedPreferences.setBool(LOGIN_KEY, state);
    _loginState = state;
    notifyListeners();
  }

  /// Sets the initialized state.
  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  /// Initializes the app.
  Future<void> onAppStart() async {
    _loginState = sharedPreferences.getBool(LOGIN_KEY) ?? false;

    await Future.delayed(Duration.zero, () {
      _initialized = true;
      notifyListeners();
    });
  }
}