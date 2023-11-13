import 'dart:convert';

import 'package:client_mobile/models/area/config.dart';

/// Represents an action in the application.
class Action {
  /// The unique identifier of the action.
  final int id;
  /// The name of the action.
  final String name;
  /// The API endpoint associated with the action.
  final String apiEndpoint;
  /// The list of parameters that the action requires.
  final List<dynamic> returnParams;
  /// A list of default configurations for the action.
  final List<Config> defaultConfig;
  /// The unique identifier of the service that the action belongs to.
  final int serviceId;

  /// Constructor for `Action` class.
  /// 
  /// - `id`: The unique identifier of the action.
  /// - `name`: The name of the action.
  /// - `apiEndpoint`: The API endpoint associated with the action.
  /// - `returnParams`: The list of parameters that the action
  /// - `defaultConfig`: A list of default configurations for the action.
  /// - `serviceId`: The unique identifier of the service that the action belongs to.
  Action({
    required this.id,
    required this.name,
    required this.apiEndpoint,
    required this.returnParams,
    required this.defaultConfig,
    required this.serviceId,
  });

  /// Factory constructor to create an [Action] object from JSON map.
  /// 
  /// - [json]: The JSON representation of the [Action] object.
  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      id: json['id'],
      name: json['name'],
      apiEndpoint: json['api_endpoint'],
      returnParams: jsonDecode(json['return_params']),
      defaultConfig: (jsonDecode(json['default_config']) as List)
          .map((e) => Config.fromJson(e))
          .toList(),
      serviceId: json['service_id'],
    );
  }
}

