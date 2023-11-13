import 'package:client_mobile/models/area/action.dart';
import 'package:client_mobile/models/area/reaction.dart';

/// Represents a service in the application.
class Service {
  /// The unique identifier for the service.
  final int id;

  /// The name of the service.
  final String name;

  /// The icon representing the service.
  final String serviceIcon;

  /// Indicates whether the service is enabled.
  final bool isEnabled;

  /// Constructor for the `Service` class.
  ///
  /// - `id`: The unique identifier for the service.
  /// - `name`: The name of the service.
  /// - `serviceIcon`: The icon representing the service.
  /// - `isEnabled`: Indicates whether the service is enabled.
  Service({
    required this.id,
    required this.name,
    required this.isEnabled,
    required this.serviceIcon,
  });

  /// Convert the service to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_enabled': isEnabled,
      'service_icon': serviceIcon,
    };
  }

  /// Factory constructor to create a [Service] object from a JSON map.
  ///
  /// - [json]: A JSON map containing service data.
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      isEnabled: json['is_enabled'],
      serviceIcon: json['service_icon'],
    );
  }

  @override
  /// Returns a string representation of the service.
  String toString() {
    return 'Service(id: $id, name: $name, isEnabled: $isEnabled, serviceIcon: $serviceIcon)';
  }
}

/// Represents the content of a service, including its associated actions and reactions.
class ServiceContent {
  /// The unique identifier for the service.
  final int id;

  /// The name of the service.
  final String name;

  /// The API endpoint associated with the service.
  final String apiEndpoint;

  /// Indicates whether the service is enabled.
  final bool isEnabled;

  /// The icon representing the service.
  final String serviceIcon;

  /// List of actions associated with the service.
  final List<Action> actions;

  /// List of reactions associated with the service.
  final List<Reaction> reactions;

  /// Constructor for the `ServiceContent` class.
  ///
  /// - `id`: The unique identifier for the service.
  /// - `name`: The name of the service.
  /// - `apiEndpoint`: The API endpoint associated with the service.
  /// - `isEnabled`: Indicates whether the service is enabled.
  /// - `serviceIcon`: The icon representing the service.
  /// - `actions`: List of actions associated with the service.
  /// - `reactions`: List of reactions associated with the service.
  ServiceContent({
    required this.id,
    required this.name,
    required this.apiEndpoint,
    required this.isEnabled,
    required this.serviceIcon,
    required this.actions,
    required this.reactions,
  });

  /// Convert the service content to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_enabled': isEnabled,
      'service_icon': serviceIcon,
      'api_endpoint': apiEndpoint,
      'actions': actions,
      'reactions': reactions,
    };
  }

  /// Factory constructor to create a `ServiceContent` object from a JSON map.
  ///
  /// - `json`: A JSON map containing service content data.
  factory ServiceContent.fromJson(Map<String, dynamic> json) {
    return ServiceContent(
      id: json['id'],
      name: json['name'],
      apiEndpoint: json['api_endpoint'],
      isEnabled: json['is_enabled'],
      serviceIcon: json['service_icon'],
      actions: (json['actions'] as List).map((e) => Action.fromJson(e)).toList(),
      reactions: (json['reactions'] as List).map((e) => Reaction.fromJson(e)).toList(),
    );
  }
}
