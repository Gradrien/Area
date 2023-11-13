import 'dart:async';
import 'dart:convert';

import 'package:client_mobile/models/area/area_content.dart';
import 'package:client_mobile/models/area/area_response.dart';
import 'package:client_mobile/models/area/service.dart';
import 'package:client_mobile/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;

/// Area service class responsible for managing user areas and interactions with the server.
class AreaService {
  /// Stream controller for the areas stream.
  final StreamController<bool> _onAuthStateChange =
      StreamController.broadcast();
  /// The storage service class.
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  /// Gets the user's IP address from storage.
  static Future<String?> getIpAddress() async {
    return await storage.read(key: 'ip');
  }

  /// Gets the user's port address from storage.
  static Future<String?> getPortAddress() async {
    return await storage.read(key: 'port');
  }

  /// Gets the server URL based on the user's IP address and port.
  static Future<Uri> getServerUrl() async {
    final ipAddress = await getIpAddress();
    final port = await getPortAddress();
    if (ipAddress != null && port != null) {
      return Uri.parse("http://$ipAddress:$port");
    } else {
      throw Exception("IP Address not found in storage.");
    }
  }

  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  /// Retrieves user areas from the server.
  /// 
  /// - `context`: The build context.
  Future<List<AreaResponse>?> getAreas(BuildContext context) async {
    try {
      AppService appService = Provider.of<AppService>(context, listen: false);
      final Uri url = await getServerUrl();

      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception("Error token");
      }
      final response = await http.get(url.resolve("/api/user/areas"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
        return null;
      }
      if (response.statusCode != 200) {
        throw Exception("Error Response");
      }
      final decoded = jsonDecode(response.body);
      final List<dynamic> decodedArea = decoded;
      return decodedArea.map((x) => AreaResponse.fromJson(x)).toList();
    } catch (e, stack) {
      print(e);
      print(stack);
      throw Exception(e);
    }
  }

  /// Retrieves the user's profile information from the server.
  /// 
  /// - `context`: The build context.
  Future<User?> getProfile(BuildContext context) async {
    AppService appService = Provider.of<AppService>(context, listen: false);
    try {
      final Uri url = await getServerUrl();
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception("Error token");
      }
      final response = await http.get(url.resolve("/api/user"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
        return null;
      }
      if (response.statusCode != 200) {
        throw Exception("Error response");
      }
      final decoded = jsonDecode(response.body);
      return User.fromJson(decoded);
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
       storage.delete(key: 'jwt');
      _onAuthStateChange.add(false);
      appService.loginState = false;
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go('/login');
      return User(id: -1, name: "Error", email: "Error", created: "Error");
    }
  }

  /// Retrieves the user's services from the server.
  /// 
  /// - `context`: The build context.
  Future<List<ServiceContent>> getServices(BuildContext context) async {
    try {
      AppService appService = Provider.of<AppService>(context, listen: false);
      final Uri url = await getServerUrl();
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception("No token");
      }
      final response =
          await http.get(url.resolve("/api/user/services"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
        return [];
      }
      if (response.statusCode != 200) {
        throw Exception("Wrong status code");
      }
      final List<dynamic> decoded = jsonDecode(response.body)["services"];
      return decoded.map((json) => ServiceContent.fromJson(json)).toList();
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      throw Exception(e);
    }
  }

  /// Retrieves the user's areas with a specified id from the server.
  /// 
  /// - `context`: The build context.
  /// - `id`: The id of the area to retrieve.
  Future<AreaData> getAreasById(BuildContext context, int id) async {
    try {
      AppService appService = Provider.of<AppService>(context, listen: false);
      final Uri url = await getServerUrl();
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception("Error token");
      }
      final response =
          await http.get(url.resolve("/api/area/$id/data"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
        return AreaData(
            id: -1,
            name: "Error",
            active: false,
            actionName: "Error",
            reactionName: "Error",
            actionIcon: "Error",
            reactionIcon: "Error",
            refresh: 0,
            actionConfig: [],
            reactionConfig: []);
      }
      if (response.statusCode != 200) {
        throw Exception("Error response");
      }
      Map<String, dynamic> areas = jsonDecode(response.body);
      areas['action_config'] = jsonDecode(areas['action_config']);
      areas['reaction_config'] = jsonDecode(areas['reaction_config']);
      return AreaData.fromJson(areas);
    } catch (e, stack) {
      print(stack);
      throw Exception(e);
    }
  }

  /// Updates the user's areas with a specified Id.
  /// 
  /// - `context`: The build context.
  /// - `updateArea`: The area to update.
  Future<bool> updateAreaById(
      BuildContext context, AreaResponse updated) async {
    try {
      AppService appService = Provider.of<AppService>(context, listen: false);
      final Uri url = await getServerUrl();
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        return false;
      }
      print(updated.refresh);
      final Map<String, dynamic> requestBody = {
        "name": updated.name,
        "active": updated.active,
        "refresh": updated.refresh,
        "action_config": json.encode(updated.actionConfig),
        "reaction_config": json.encode(updated.reactionConfig),
      };
      final response = await http.put(
        url.resolve("/api/area/${updated.id}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestBody),
      );
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
        return false;
      }
      if (response.statusCode != 200) {
        print('pas bon');
        // ignore: use_build_context_synchronously
        showErrorMessage("Erreur update : ${jsonDecode(response.body)['message']}", context);
        return false;
      }
      print("finish with success");
      return true;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      // throw Exception(e);
      return false;
    }
  }

  /// Creates an area
  /// 
  /// - `context`: The build context.
  /// - `content`: The area to create.
  Future<AreaResponse> createArea(
      BuildContext context, AreaContent content) async {
    try {
      AppService appService = Provider.of<AppService>(context, listen: false);
      final Uri url = await getServerUrl();
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception("Error token");
      }
      final response = await http.post(
        url.resolve("/api/area"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          'name': content.name.toString(),
          'action_id': content.actionId.toString(),
          'reaction_id': content.reactionId.toString(),
          'refresh': content.refresh.toString(),
        },
      );
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
      }
      if (response.statusCode != 201) {
        print(response.body);
        throw Exception("Error response");
      }
      final decoded = jsonDecode(response.body);
      return AreaResponse.fromJson(decoded);
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      throw Exception(e);
    }
  }

  /// Retrieves all the user's services from the server.
  /// 
  /// - `context`: The build context.
  Future<List<ServiceContent>?> getAllUserServices(BuildContext context) async {
    try {
      AppService appService = Provider.of<AppService>(context, listen: false);
      final Uri url = await getServerUrl();
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception("Error Token");
      }
      final response =
          await http.get(url.resolve("/api/user/services"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
        return [];
      }
      if (response.statusCode != 200) {
        throw Exception("Error response");
      }
      final decoded = jsonDecode(response.body)["services"];
      return decoded.map((json) => ServiceContent.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Deletes an area with a specified id.
  /// 
  /// - `context`: The build context.
  /// - `id`: The id of the area to delete.
  Future<bool> deleteAreaById(BuildContext context, int id) async {
    try {
      AppService appService = Provider.of<AppService>(context, listen: false);
      final Uri url = await getServerUrl();
      final String? token = await storage.read(key: 'jwt');
      if (token == null) {
        throw Exception("Error token");
      }
      final response =
          await http.delete(url.resolve("/api/area/$id"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 401) {
        if (!context.mounted) throw Exception("Error context");
        storage.delete(key: 'jwt');
        _onAuthStateChange.add(false);
        appService.loginState = false;
        GoRouter.of(context).go('/login');
        return false;
      }
      if (response.statusCode != 200) {
        throw Exception("Error status code");
      }
      return true;
    } catch (e) {
      throw Exception("Cannot delete area");
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
