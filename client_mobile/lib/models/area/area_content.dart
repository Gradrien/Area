import 'package:client_mobile/models/area/config.dart';

/// Represents the content of an area.
class AreaContent {
  /// The name of the area
  String? name;
  /// The ID of the associated action.
  int? actionId;
  /// The ID of the associated reaction.
  int? reactionId;
  /// The refresh interval for the area.
  int? refresh;

  /// Constructor for `AreaContent` class.
  /// 
  /// - `name`: The name of the area.
  /// - `actionId`: The ID of the action associated with the area.
  /// - `reactionId`: The ID of the reaction associated with the area.
  /// - `refresh`: The refresh interval for the area.
  AreaContent({
    this.name,
    this.actionId,
    this.reactionId,
    this.refresh,
  });
}

/// Represents the data of an area.
class AreaData {
  /// The name of the area.
  final String name;
  /// Indicates whether the area is active.
  bool active;
  /// The name of the associated action.
  final String actionName;
  /// Configuration for the associated action.
  final List<Config> actionConfig;
  /// The name of the associated reaction.
  final String reactionName;
  /// Configuration for the associated reaction.
  final List<Config> reactionConfig;
  /// The icon for the associated action.
  final String actionIcon;
  /// The icon for the associated reaction.
  final String reactionIcon;
  /// The ID of the area.
  final int id;
  /// The refresh interval for the area.
  final int refresh;

  /// Constructor for `AreaData` class.
  /// 
  /// - `name`: The name of the area.
  /// - `active`: Indicates whether the area is active.
  /// - `actionName`: The name of the associated action.
  /// - `actionConfig`: The configuration for the associated action.
  /// - `reactionName`: The name of the associated reaction.
  /// - `reactionConfig`: The configuration for the associated reaction.
  /// - `actionIcon`: The icon for the associated action.
  /// - `reactionIcon`: The icon for the associated reaction.
  /// - `id`: The ID of the area.
  /// - `refresh`: The refresh interval for the area.
  AreaData({
    required this.name,
    required this.active,
    required this.actionName,
    required this.actionConfig,
    required this.reactionName,
    required this.reactionConfig,
    required this.actionIcon,
    required this.reactionIcon,
    required this.id,
    required this.refresh,
  });

  /// Factory constructor to create an [AreaData] object from a JSON map.
  /// 
  /// - [json]: The JSON representation of the [AreaData] object.
  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
      name: json['name'],
      active: json['active'],
      actionName: json['action_name'],
      actionConfig: List<Config>.from(
          json['action_config'].map((x) => Config.fromJson(x))),
      reactionName: json['reaction_name'],
      reactionConfig: List<Config>.from(
          json['reaction_config'].map((x) => Config.fromJson(x))),
      actionIcon: json['action_icon'],
      reactionIcon: json['reaction_icon'],
      id: json['id'],
      refresh: json['refresh'],
    );
  }
  @override
  /// Returns a [String] representation of the [AreaData] object.
  String toString() {
    return 'AreaData(id: $id, actionName: $actionName, reactionName: $reactionName, actionIcon: $actionIcon, reactionIcon: $reactionIcon, refresh: $refresh, active: $active, actionConfig: ${actionConfig.map((config) => config.toString()).toList()}, reactionConfig: ${reactionConfig.map((config) => config.toString()).toList()})'; 
  }
}
