import 'dart:async';

import 'package:client_mobile/models/area/area_content.dart';
import 'package:client_mobile/models/area/area_response.dart';
import 'package:client_mobile/models/editable_text.dart';
import 'package:client_mobile/nav/nav.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';

import 'package:client_mobile/views/area_setting_view.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:client_mobile/views/create_area_view.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// A widget representing the view of an area.
class AreaView extends StatefulWidget {
  /// Constructor for the `AreaView` widget.
  const AreaView({Key? key}) : super(key: key);

  @override
  State<AreaView> createState() => _AreaViewState();
}

/// The state of the [AreaView] widget.
class _AreaViewState extends State<AreaView> {
  /// A key for the RefreshIndicator widget to enable manual refreshing.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    final areaService = Provider.of<AreaService>(context, listen: true);
    List<AreaResponse> areas = [];
    return FutureBuilder(
        future: areaService.getAreas(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  height: 600,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAreaView()));
                    },
                    child: AreaContainer(
                      padding: const EdgeInsets.only(
                          left: 19, right: 19, top: 22, bottom: 34),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Créer ma premère Area",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          SvgPicture.asset("assets/add.svg",
                              height: 32, width: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              areas = snapshot.data as List<AreaResponse>;
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  final area = await areaService.getAreas(context);
                  setState(() {
                    areas = area!;
                  });
                },
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    height: 600,
                    child: ListView.builder(
                      itemCount: areas.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = areas[index];
                        return AreaContainer(
                          padding: const EdgeInsets.only(
                              left: 19, right: 19, top: 21.5, bottom: 33.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: AreaTopBar(item: item),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SmallContainer(
                                    brandIcon: SvgPicture.network(
                                        item.actionIcon,
                                        width: 48,
                                        height: 48),
                                    title: item.actionName,
                                  ),
                                  SmallContainer(
                                    brandIcon: SvgPicture.network(
                                        item.reactionIcon,
                                        width: 48,
                                        height: 48),
                                    title: item.reactionName,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text("Error occured"));
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error occured"));
          } else {
            return const SizedBox(
              height: 100,
              width: 100,
              );
          }
        });
  }
}

/// A widget representing a container for an area.
class AreaContainer extends StatelessWidget {
  /// The child widget to be placed inside the container.
  final Widget child;
  /// The padding applied to the container.
  final EdgeInsetsGeometry padding;

  /// Constructor for the `AreaContainer` widget.
  /// 
  /// - `child`: The child widget to be placed inside the container.
  /// - `padding`: The padding applied to the container.
  const AreaContainer({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return GlassContainerRounded(
      colorOpacity: 0.5,
      height: 210,
      width: 360,
      borderColor: Colors.white,
      borderRadius: 30,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 16.0),
      padding: padding,
      child: child,
    );
  }
}

/// A small container widget containing brand icon and title.
class SmallContainer extends StatelessWidget {
  /// The brand icon represented as an SvgPicture.
  final SvgPicture brandIcon;
  /// The title associated with the brand.
  final String title;

  /// Constructor for the `SmallContainer` widget.
  /// 
  /// - `brandIcon`: The brand icon represented as an `SvgPicture`.
  /// - `title`: The title associated with the brand.
  const SmallContainer(
      {super.key, required this.brandIcon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 151,
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: const Color.fromARGB(45, 45, 45, 30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: brandIcon,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(title,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

/// A top bar widget that displays the title, settings icon, and the state of the AREA.
class AreaTopBar extends StatefulWidget {
  /// The `AreaResponse` item representing the AREA details.
  AreaResponse item;

  /// Constructor for the `AreaTopBar` widget.
  ///
  /// - `item`: The `AreaResponse` item representing the AREA details.
  AreaTopBar({super.key, required this.item});

  @override
  State<AreaTopBar> createState() => _AreaTopBarState();
}

/// The state of the [AreaTopBar] widget.
class _AreaTopBarState extends State<AreaTopBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              // Ensure the text takes up all available horizontal space
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!widget.item.active)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.brightness_1,
                        color: Colors.red,
                        size: 7.5,
                        semanticLabel: "AREA is inactive",
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.brightness_1,
                        color: Colors.green,
                        size: 7.5,
                        semanticLabel: "AREA is active",
                      ),
                    ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.item.name,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AreaSettingsView(
                              areaResponse: widget.item,
                            )));
              },
              child: SvgPicture.asset("assets/settings.svg",
                  height: 28, width: 28),
            )
          ],
        )
      ],
    );
  }
}

/// A widget for the top bar of AREA settings, displaying the title and settings icon.
class SettingsAreaTopBar extends StatefulWidget {
  /// The `AreaResponse` item representing the AREA details.
  AreaResponse item;

  /// Constructor for the `SettingsAreaTopBar` widget.
  /// 
  /// - `item`: The `AreaResponse` item representing the AREA details.
  SettingsAreaTopBar({super.key, required this.item});

  @override
  State<SettingsAreaTopBar> createState() => _SettingsAreaTopBarState();
}

/// The state of the [SettingsAreaTopBar] widget.
class _SettingsAreaTopBarState extends State<SettingsAreaTopBar> {
  @override
  Widget build(BuildContext context) {
    final areaService = Provider.of<AreaService>(context, listen: false);
    String name = widget.item.name;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MyEditableText(
                initialText: name,
                onChanged: (String newText) {
                  widget.item.name = newText;
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  areaService.deleteAreaById(context, widget.item.id);
                  Navigator.pop(context);
                },
                child:
                    SvgPicture.asset("assets/trash.svg", height: 32, width: 32),
              ),
            ],
          )
        ],
      ),
    );
  }
}
