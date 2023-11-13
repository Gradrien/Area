import 'dart:convert';

import 'package:client_mobile/models/area/config.dart';

/// Represents a reaction in the application.
class Reaction {
  /// The unique identifier for the reaction.
  final int id;

  /// The name of the reaction.
  final String name;

  /// The API endpoint associated with the reaction.
  final String apiEndpoint;

  /// Parameters for the reaction as a JSON map.
  final Map<String, dynamic> params;

  /// A list of default configurations for the reaction.
  final List<Config> defaultConfig;

  /// The identifier of the service to which this reaction belongs.
  final int serviceId;

  /// Constructor for the `Reaction` class.
  ///
  /// - `id`: The unique identifier for the reaction.
  /// - `name`: The name of the reaction.
  /// - `apiEndpoint`: The API endpoint associated with the reaction.
  /// - `params`: Parameters for the reaction as a JSON map.
  /// - `defaultConfig`: A list of default configurations for the reaction.
  /// - `serviceId`: The identifier of the service to which this reaction belongs.
  Reaction({
    required this.id,
    required this.name,
    required this.apiEndpoint,
    required this.params,
    required this.defaultConfig,
    required this.serviceId,
  });

  /// Factory constructor to create a [Reaction] object from a JSON map.
  ///
  /// - [json]: A JSON map containing reaction data.
  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'],
      name: json['name'],
      apiEndpoint: json['api_endpoint'],
      params: jsonDecode(json['params']),
      defaultConfig: (jsonDecode(json['default_config']) as List)
          .map((e) => Config.fromJson(e))
          .toList(),
      serviceId: json['service_id'],
    );
  }
}
