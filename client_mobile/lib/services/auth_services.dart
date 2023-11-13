import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';

final callbackUrlScheme = dotenv.env['CALLBACK_URL_SCHEME_GOOGLE']!;
final callbackUrlSchemeMicrosoft = dotenv.env['CALLBACK_URL_SCHEME_MICROSOFT']!;
final callbackUrlSchemeSpotify = dotenv.env['CALLBACK_URL_SCHEME_SPOTIFY']!;
final callbackUrlSchemeGitlab = dotenv.env['CALLBACK_URL_SCHEME_GITLAB']!;

/// Auth Service class responsible for handling the authentication flow and oauth2 authentication
class AuthService {
  /// Stream controller for listening to the auth state changes
  final StreamController<bool> _onAuthStateChange = StreamController.broadcast();
  /// The storage service class.
  final storage = const FlutterSecureStorage(); 

  /// Gets the user's IP address from the storage.
  Future<String?> getIpAddress() async {
    return await storage.read(key: 'ip');
  }

  /// Gets the user's port address from the storage.
  Future<String?> getPortAddress() async {
    return await storage.read(key: 'port');
  }

  /// Gets the server URL based on the user"s IP address and port.
  Future<Uri> getServerUrl() async {
    final ipAddress = await getIpAddress();
    final port = await getPortAddress();
    if (ipAddress != null && port != null) {
      return Uri.parse("http://$ipAddress:$port");
    } else {
      throw Exception("IP Address not found in storage.");
    }
  }

  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  /// Gets the user's token from the storage.
  Future<String?> getToken() async {
    try {
      final token = await storage.read(key: "jwt");
      return token;
    } catch (e) {
      return null;
    }
  }

  /// Gets the user from the storage.
  Future<User?> getUser() async {
    try {
      final userString = await storage.read(key: "user");
      if (userString == null) {
        return null;
      }
      final data = jsonDecode(userString);
      return User(id: data['id'], name: data['name'], email: data['user']['email'], created: data['user']['created_at']);
    } catch (e) {
      print("error when constructing user: $e");
      return null;
    }
  }

  /// This function allows the user to log in using a username (email) and password.
  /// 
  /// - `username`: The username of the user.
  /// - `password`: The password of the user.
  /// - `context`: The context in which the user is being logged in.
  Future<User?> login(String username, String password, BuildContext context) async {
    try {
      final Uri url = await getServerUrl();
      final response = await http.post(
        url.resolve("/api/auth/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"email": username, "password": password}),
      );
      if (response.statusCode != 200) {
        // ignore: use_build_context_synchronously
        showErrorMessage("Erreur de connexion : ${jsonDecode(response.body)['message']}", context);
        return null;
      }
      final data = await jsonDecode(response.body);
      print(data);
      final token = data["authorization"]["token"];
      print(token);
      final user = User.fromJson(data["user"]);
      print(user);
      await storage.write(key: "jwt", value: token);
      await storage.write(key: 'user', value: jsonEncode(data['user']));
      _onAuthStateChange.add(true);
      return user;
    } catch (e) {
      // ignore: use_build_context_synchronously
      showErrorMessage("Error Login: $e", context);
      print("Error Login: $e");
      return null;
    }
  }

  /// This function allows the user to register by providing an email, username, password, and password confirmation.
  /// 
  /// - `email`: The email of the user.
  /// - `username`: The username of the user.
  /// - `password`: The password of the user.
  /// - `passwordConfirmation`: The password confirmation of the user.
  /// - `context`: The context in which the user is being registered.
  Future<bool> register(String email, String username, String password, String passwordConfirmation, BuildContext context) async {
    try {
      print("request register");
      final Uri url = await getServerUrl();
      final response = await http.post(
        url.resolve("/api/auth/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "name": username,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );
      print("register get response");
      if (response.statusCode != 201) {
        // ignore: use_build_context_synchronously
        showErrorMessage("Erreur de register : ${jsonDecode(response.body)['message']}", context);
        print("Error response status code: ${response.statusCode}");
        return false;
      }
      print("register response code is ok");
      return true;
    } catch (e) {
      print("Error Register: $e");
      // ignore: use_build_context_synchronously
      showErrorMessage("Erreur de register : $e", context);
      return false;
    }
  }

  /// This function allows the user to log out by removing the JWT token and user information from secure storage.
  Future logOut() async {
    try {
      final Uri url = await getServerUrl();
      final token = await getToken();
      if (token == null) {
        return throw ("Error token not found");
      }
      final response = await http.post(
        url.resolve("/api/auth/logout"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode!= 200) {
        return throw ("Error response status code: ${response.statusCode}");
      }
      await storage.delete(key: "jwt");
      await storage.delete(key: "user");
      _onAuthStateChange.add(false);
    } catch (e) {
      print("Error Logout: $e");
    }
  }

  /// This function performs OAuth authentication using a code received from a third-party provider.
  Future<void> performOAuthSignIn(String endpoint, String code) async {
    try {
      final Uri url = await getServerUrl();
      String ?tokn = await getToken();
      if (tokn == null) {
        throw Exception("Error getting token");
      }
      final response = await http.post(
        url.resolve(endpoint),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $tokn",
        },
        body: jsonEncode({"code": code, "type": "mobile"}),
      );
      print(response.body);
      if (response.statusCode != 201) {
        print("Status code is not good");
        throw ("Error response status code: ${jsonDecode(response.body)}");
      }
      final data = await jsonDecode(response.body);
    } catch (e) {
      throw Exception("Error in performOAuthSignIn: $e");
    }
  }

  /// This function performs OAuth authentication with Microsoft.
  /// 
  /// - `code`: The code received from the third-party provider.
  Future<void> getMicrosoftUser(String code) async {
    return performOAuthSignIn("/api/oauth/microsoft", code);
  }

  /// This function performs OAuth authentication with Spotify
  /// 
  /// - `code`: The code received from the third-party provider.
  Future<void> getSpotify(String code) async {
    return performOAuthSignIn("/api/oauth/spotify", code);
  }

  /// This function performs OAuth authentication with Google.
  /// 
  /// - `code`: The code received from the third-party provider.
  Future<void> getGoogle(String code) async {
    return performOAuthSignIn("/api/oauth/google-service", code);
  }

  /// This function performs OAuth authentication with Gitlab.
  /// 
  /// - `code`: The code received from the third-party provider.
  Future<void> getGitlab(String code) async {
    return performOAuthSignIn("/api/oauth/gitlab", code);
  }

  /// This function performs authentication with Google using a code and updates the user information.
  /// 
  /// - `code`: The code received from the third-party provider.
  Future<void> getGoogleUser(String code) async {
    try {
      final Uri url = await getServerUrl();
      final response = await http.post(
        url.resolve("/api/auth/google-signin"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"code": code, "redirect": '$callbackUrlScheme:/', "type": "mobile"}),
      );
      if (response.statusCode != 200) {
        print("status code pas good");
        throw ("Error response status code: ${jsonDecode(response.body)}");
      }
      print("status code good");
      final data = await jsonDecode(response.body);
      print(data);
      final token = data["authorization"]["token"];
      final user = User(id: data['user']['id'], name: data['user']['name'], email: data['user']['email'], created: data['user']['created_at']);
      await storage.write(key: "jwt", value: token);
      await storage.write(key: "user", value: jsonEncode(data['user']));
      _onAuthStateChange.add(true);
    } catch (e) {
      throw Exception("error in getGoogleUser $e");
    }
  }

  /// This function allows the user to log in with Google using a web interface.
  Future<void> loginWithGoogle() async {
    try {
      final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'response_type': 'code',
        'client_id':  dotenv.env['GOOGLE_CLIENT_ID']!,
        'redirect_uri': '$callbackUrlScheme:/',
        'access_type': 'offline',
        'scope': 'email profile https://www.googleapis.com/auth/gmail.modify https://www.googleapis.com/auth/drive',
      });
      final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);
      final code = Uri.parse(result).queryParameters['code'];
      print(code);
      if (code == null) {
        print("pas code");
        throw Exception("Failed to get code");
      }
      await getGoogleUser(code);
      // print(test);
      // return null;
    } catch (e) {
      throw Exception("Error Login Google $e");
    }
  }
  
  /// This function allows the user to log in with Microsoft using a web interface.
  Future<void> loginWithMicrosoft() async {
    try {
      final url = Uri.https('login.microsoftonline.com', '/common/oauth2/v2.0/authorize', {
        'response_type': 'code',
        'client_id': dotenv.env['MICROSOFT_CLIENT_ID']!,
        'redirect_uri': '$callbackUrlSchemeMicrosoft://auth',
        'scope': 'offline_access user.read Mail.Send Calendars.Read Notes.Create',
      });
      final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlSchemeMicrosoft);
      print("--------------AFTER RESULT------------------");
      print(result);
      final code = Uri.parse(result).queryParameters['code'];
      print(code);
      if (code == null) {
        print("pas code");
        throw Exception("Error authent");
      }
      await getMicrosoftUser(code);
    } catch (e) {
      throw Exception("Error with Microsoft: $e");
    }
  }

  /// This function allows the user to log in with Spotify using a web interface.
  Future<bool> loginWithSpotify() async {
    try {
      final url = Uri.https('accounts.spotify.com', '/authorize', {
        'response_type': 'code',
        'client_id':  dotenv.env['SPOTIFY_CLIENT_ID']!,
        'redirect_uri': '$callbackUrlSchemeSpotify:/',
        'scope': 'user-read-private user-follow-modify user-modify-playback-state user-read-playback-state',
        'access_type': 'offline'
      });
      final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlSchemeSpotify);
      print("--------------AFTER RESULT------------------");
      print(result);
      final code = Uri.parse(result).queryParameters['code'];
      print(code);
      if (code == null) {
        print("pas code");
        return false;
      }
      await getSpotify(code);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// This function allows the user to log in with Google services using a web interface.
  Future<void> loginWithGoogleService() async {
    try {
      final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'response_type': 'code',
        'client_id':  dotenv.env['GOOGLE_CLIENT_ID']!,
        'redirect_uri': '$callbackUrlScheme:/',
        'scope': 'email profile https://www.googleapis.com/auth/gmail.modify https://www.googleapis.com/auth/drive',
      });
      final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);
      final code = Uri.parse(result).queryParameters['code'];
      print(code);
      if (code == null) {
        print("pas code");
        throw Exception("Error authent");
      }
      await getGoogle(code);
    } catch (e) {
      throw Exception("Failed to connect to oauth google $e");
    }
  }

  /// This function allows the user to log in with Gitlab using a web interface.
  Future<void> loginWithGitlab() async {
    try {
      final url = Uri.https('gitlab.com', '/oauth/authorize', {
        'response_type': 'code',
        'client_id': dotenv.env['GITLAB_CLIENT_ID']!,
        'redirect_uri': '$callbackUrlSchemeGitlab://oauth2',
        'scope': 'read_repository write_repository api'
      });
      final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlSchemeGitlab);
      print("--------------AFTER RESULT------------------");
      print(result);
      final code = Uri.parse(result).queryParameters['code'];
      print(code);
      if (code == null) {
        print("pas code");
        throw Exception("Error authent");
      }
      await getGitlab(code);
    } catch (e) {
      throw Exception("Failed to connect to oauth Gitlab $e");
    }
  }

  /// This function allows the user to register using a Google account and an authentication code.
  /// 
  /// - `code`: The authentication code received from the third-party provider.
  Future<bool> registerGoogleUser(String code) async {
    try {
      print("send to back");
      final Uri url = await getServerUrl();
      final response = await http.post(
        url.resolve("/api/auth/google-signup"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"code": code, "redirect": '$callbackUrlScheme:/', "type": "mobile"}),
      );
      if (response.statusCode != 201) {
        print("status code pas good");
        return throw ("Error response status code: ${jsonDecode(response.body)}");
      }
      return true;
    } catch (e) {
      print("error in getGoogleUser $e");
      return false;
    }
  }

  /// This function allows the user to register using a Google account using a web interface.
  Future<bool> registerWithGoogle() async {
    try {
      final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'response_type': 'code',
        'client_id':  dotenv.env['GOOGLE_CLIENT_ID']!,
        'redirect_uri': '$callbackUrlScheme:/',
        'access_type': 'offline',
        'scope': 'email profile https://www.googleapis.com/auth/gmail.modify https://www.googleapis.com/auth/drive',
        'prompt': 'consent'
      });

      final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);

      final code = Uri.parse(result).queryParameters['code'];
      print(code);
      if (code == null) {
        print("pas code");
        return false;
      }
      return registerGoogleUser(code);
    } catch (e) {
      print("Error with google: $e");
      return false;
    }
  }

  /// This function refreshes the user's JWT token in case of expiration.
  Future<User?> refreshToken() async {
    try {
      final token = await getToken();
      final Uri url = await getServerUrl();
      if (token == null) {
        throw Exception("Error token");
      }
      final response = await http.post(
        url.resolve("/api/auth/refresh"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }
      );
      if (response.statusCode != 200) {
        throw Exception("Error response");
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String newToken = data['authorization']['token'];
      await storage.write(key: 'jwt', value: newToken);
      return User.fromJson(data['user']);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// This function allows the user to delete a service associated with the user using its ID.
  /// 
  /// - `id`: The ID of the service to be deleted.
  Future<bool> deleteService(int id) async {
    try {
      final token = await getToken();
      final Uri url = await getServerUrl();
      if (token == null) {
        throw Exception("Error get token");
      }
      final response = await http.delete(
        url.resolve("/api/services/$id"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }
      );
      if (response.statusCode != 201) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// This function allows the user to start an area inside queue with the specified id.
  /// 
  /// - `id` : The ID of the area to be started.
  Future<bool> startArea(int id) async {
    try {
      final token = await getToken();
      final Uri url = await getServerUrl();
      if (token == null) {
        throw Exception("Error get token");
      }
      final response = await http.post(
        url.resolve("/api/area/$id/start"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }
      );
      if (response.statusCode != 200) {
        print("Error status: ${response.statusCode}");
        return false;
      }
      return true;
    } catch (e ) {
      return false;
    }
  }
}

/// Displays an error message in the bottom of the screen.
/// 
/// - `message`: The message to display.
/// - `context`: The build context.
void showErrorMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}


