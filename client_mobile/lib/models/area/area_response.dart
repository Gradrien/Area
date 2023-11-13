// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:client_mobile/models/area/config.dart';

/// Represents an area response.
class AreaResponse {
  /// The name of the area.
  String name;

  /// The name of the associated action.
  String actionName;

  /// Configuration for the associated action.
  List<Config>? actionConfig;

  /// The name of the associated reaction.
  String reactionName;

  /// Configuration for the associated reaction.
  List<Config>? reactionConfig;

  /// The icon for the associated action.
  String actionIcon;

  /// The icon for the associated reaction.
  String reactionIcon;

  /// The unique identifier for the area.
  int id;

  /// The refresh interval for the area.
  int refresh;

  /// Indicates whether the area is active.
  bool active;

  /// Constructor for the `AreaResponse` class.
  ///
  /// - `name`: The name of the area.
  /// - `actionName`: The name of the associated action.
  /// - `actionConfig`: Configuration for the associated action.
  /// - `reactionName`: The name of the associated reaction.
  /// - `reactionConfig`: Configuration for the associated reaction.
  /// - `actionIcon`: The icon for the associated action.
  /// - `reactionIcon`: The icon for the associated reaction.
  /// - `id`: The unique identifier for the area.
  /// - `refresh`: The refresh interval for the area.
  /// - `active`: Indicates whether the area is active.
  AreaResponse({
    required this.name,
    required this.actionName,
    this.actionConfig,
    required this.reactionName,
    this.reactionConfig,
    required this.actionIcon,
    required this.reactionIcon,
    required this.id,
    required this.refresh,
    required this.active,
  });

  /// Factory constructor to create an [AreaResponse] object from a JSON map.
  ///
  /// - [json]: A JSON map containing area response data.
  factory AreaResponse.fromJson(Map<String, dynamic> json) {
    return AreaResponse(
      name: json['name'],
      actionName: json['action_name'],
      actionConfig: json['action_config'] != null
          ? (jsonDecode(json['action_config']) as List)
              .map((e) => Config.fromJson(e))
              .toList()
          : null,
      reactionName: json['reaction_name'],
      reactionConfig: json['reaction_config'] != null
          ? (jsonDecode(json['reaction_config']) as List)
              .map((e) => Config.fromJson(e))
              .toList()
          : null,
      actionIcon: json['action_icon'],
      reactionIcon: json['reaction_icon'],
      id: json['id'],
      refresh: int.tryParse(json['refresh'].toString()) ?? 1,
      active: json['active'] ?? true,
    );
  }

  @override
  /// String representation of the [AreaResponse] object.
  String toString() {
    return 'AreaResponse(id: $id, name: $name, actionName: $actionName, actionConfig: $actionConfig, reactionName: $reactionName, reactionConfig: $reactionConfig, actionIcon: $actionIcon, reactionIcon: $reactionIcon, refresh: $refresh, active: $active)';
  }
}
