import 'package:client_mobile/models/area/area_content.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:client_mobile/models/area/service.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

/// Action to select an area.
class SelectAreaAction extends StatefulWidget {
  /// The area content to select.
  final AreaContent areacontent;

  /// Constructor for `SelectAreaAction` class.
  /// 
  /// - `areacontent`: The area content to select.
  const SelectAreaAction({super.key, required this.areacontent});

  @override
  _SelectAreaActionState createState() => _SelectAreaActionState();
}

/// State class for [SelectAreaAction] class.
class _SelectAreaActionState extends State<SelectAreaAction> {
  /// Index of the selected tile.
  int? selectedTileIndex;
  /// List of areas.
  Future<List<dynamic>> future = Future.value([]);
  /// Services for the area.
  late AreaService areaService;

  @override
  void initState() {
    areaService = Provider.of<AreaService>(context, listen: false);
    future = fetchActionAreas(context, areaService, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> choiceList = [];
    Color defaultBorderColor = Colors.white;

    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          choiceList = snapshot.data!;
          return SizedBox(
            height: 305,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: GroupedListView(
                      elements: choiceList,
                      groupBy: (choiceList) => choiceList.service,
                      itemBuilder: (context, choiceList) => Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 16.0),
                        child: ListTile(
                          title: GlassContainerRounded(
                            height: 50,
                            width: double.infinity,
                            borderRadius: 15,
                            borderColor: selectedTileIndex == choiceList.id
                                ? const Color(0xFF4C5AF6)
                                : defaultBorderColor,
                            colorOpacity: 0.6,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      choiceList.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedTileIndex = choiceList.id;
                            });
                            widget.areacontent.actionId = choiceList.actionId;
                          },
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      groupSeparatorBuilder: (String service) {
                        var icon = choiceList
                            .firstWhere((element) => element.service == service)
                            .icon;
                        return Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  icon,
                                  const SizedBox(width: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      service,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(
                                child: Divider(
                                  color: Colors.grey,
                                  height: 20,
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

/// Reaction action to select an area.
class SelectAreaReaction extends StatefulWidget {
  /// The area content to select.
  final AreaContent areacontent;
  /// Constructor for `SelectAreaReaction` class.
  /// 
  /// - `areacontent`: The area content to select.
  const SelectAreaReaction({super.key, required this.areacontent});

  @override
  _SelectAreaReactionState createState() => _SelectAreaReactionState();
}

/// State class for [SelectAreaReaction] class.
class _SelectAreaReactionState extends State<SelectAreaReaction> {
  /// Index of the selected tile.
  int? selectedTileIndex;
  /// List of areas.
  Future<List<dynamic>> future = Future.value([]);
  /// Services for the area.
  late AreaService areaService;

  @override
  void initState() {
    areaService = Provider.of<AreaService>(context, listen: false);
    future = fetchActionAreas(context, areaService, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> choiceList = [];
    Color defaultBorderColor = Colors.white;

    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          choiceList = snapshot.data!;
          return SizedBox(
            height: 305,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: GroupedListView(
                      elements: choiceList,
                      groupBy: (choiceList) => choiceList.service,
                      itemBuilder: (context, choiceList) => Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0, bottom: 16.0),
                        child: GlassContainerRounded(
                          height: 50,
                          width: double.infinity,
                          borderColor: selectedTileIndex == choiceList.id
                              ? const Color(0xFF4C5AF6)
                              : defaultBorderColor,
                          borderRadius: 15,
                          colorOpacity: 0.6,
                          child: ListTile(
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Text(
                                      choiceList.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedTileIndex = choiceList.id;
                              });
                              widget.areacontent.reactionId =
                                  choiceList.reactionId;
                            },
                          ),
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      groupSeparatorBuilder: (String service) {
                        var icon = choiceList
                            .firstWhere((element) => element.service == service)
                            .icon;
                        return Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  icon,
                                  const SizedBox(width: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      service,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(
                                child: Divider(
                                  color: Colors.grey,
                                  height: 20,
                                  thickness: 2,
                                  indent: 0,
                                  endIndent: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

/// Representation of an action area.
class ActionArea {
  /// Id of the action area.
  final int id;
  /// Id of the action.
  final int actionId;
  /// Name of the service.
  final String service;
  /// Name of the action area.
  final String name;
  /// Icon of the action area.
  final SvgPicture icon;
  /// List of actions.
  final List<dynamic> action;

  /// Constructor for `ActionArea` class.
  /// 
  /// - `id`: Id of the action area.
  /// - `actionId`: Id of the action.
  /// - `service`: Name of the service.
  /// - `name`: Name of the action area.
  /// - `icon`: Icon of the action area.
  /// - `action`: List of actions.
  ActionArea({
    required this.id,
    required this.actionId,
    required this.service,
    required this.name,
    required this.icon,
    required this.action,
  });
}


/// Representation of an Reaction area.
class ReactionArea {
  /// Id of the reaction area.
  final int id;
  /// Id of the reaction.
  final int reactionId;
  /// Name of the service.
  final String service;
  /// Name of the reaction area.
  final String name;
  /// Icon of the reaction area.
  final SvgPicture icon;
  /// List of reactions.
  final List<dynamic> reaction;

  /// Constructor for `ReactionArea` class.
  /// 
  /// - `id`: Id of the reaction area.
  /// - `reactionId`: Id of the reaction.
  /// - `service`: Name of the service.
  /// - `name`: Name of the reaction area.
  /// - `icon`: Icon of the reaction area.
  /// - `reaction`: List of reactions.
  ReactionArea({
    required this.id,
    required this.reactionId,
    required this.service,
    required this.name,
    required this.icon,
    required this.reaction,
  });
}

/// Fetches a list of action or reaction areas based on the specified flag.
///
/// `context` - The BuildContext.
/// `areaService` - An instance of the AreaService.
/// `fetchAction` - A flag indicating whether to fetch action areas (true) or reaction areas (false).
///
/// Returns a Future that resolves to a list of action areas or reaction areas.
Future<List<dynamic>> fetchActionAreas(
    BuildContext context, AreaService areaService, bool fetchAction) async {
  final List<ServiceContent> services = await areaService.getServices(context);

  List<ActionArea> actionAreas = [];
  int index = 0;
  List<ReactionArea> reactionAreas = [];
  for (var service in services) {
    if (!service.isEnabled) {
      continue;
    }
    if (fetchAction) {
      for (var action in service.actions) {
        actionAreas.add(ActionArea(
          id: index,
          actionId: action.id,
          service: service.name,
          name: action.name,
          icon: SvgPicture.network(service.serviceIcon, width: 24, height: 24),
          action: [action],
        ));
        index++;
      }
    } else {
      for (var reaction in service.reactions) {
        reactionAreas.add(ReactionArea(
          id: index,
          reactionId: reaction.id,
          service: service.name,
          name: reaction.name,
          icon: SvgPicture.network(service.serviceIcon, width: 24, height: 24),
          reaction: [reaction],
        ));
        index++;
      }
    }
  }
  if (fetchAction) {
    return actionAreas;
  } else {
    return reactionAreas;
  }
}
