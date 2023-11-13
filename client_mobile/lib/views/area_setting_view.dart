import 'package:flutter_svg/flutter_svg.dart';
import 'package:client_mobile/models/area/area_content.dart';
import 'package:client_mobile/models/area/area_response.dart';
import 'package:client_mobile/models/area/config.dart';
import 'package:client_mobile/models/area/config_variable.dart';
import 'package:client_mobile/models/area/service.dart';
import 'package:client_mobile/models/area_container.dart';
import 'package:client_mobile/models/creation_flow/area_configuration.dart';
import 'package:client_mobile/models/helper.dart';
import 'package:client_mobile/models/input_field.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';

/// View for area settings
class AreaSettingsView extends StatefulWidget {
  /// The area response data.
  late AreaResponse areaResponse;
  // final Function(AreaResponse) onUpdateAreaResponse;

  /// Constructor for `AreaSettingsView` widget.
  ///
  /// - `areaResponse`: The area response data.
  AreaSettingsView({super.key, required this.areaResponse});

  @override
  State<AreaSettingsView> createState() => _AreaSettingsViewState();
}

/// State for `AreaSettingsView` widget.
class _AreaSettingsViewState extends State<AreaSettingsView> {
  /// The area service instance.
  late AreaService areaService;

  /// Future holder value.
  Future future = Future.value([]);

  /// List holder value.
  Future<List<dynamic>> future2 = Future.value([]);
  TextEditingController refreshController = TextEditingController();
  late AreaData areaData;

  @override
  void initState() {
    areaService = Provider.of<AreaService>(context, listen: false);
    future = areaService.getAreasById(context, widget.areaResponse.id);
    future2 = fetchAreasConfig(context, areaService, widget.areaResponse);
    refreshController.text = widget.areaResponse.refresh.toString();
    super.initState();
  }

  /// Find the type of the keyboard based on the HTML form type.
  ///
  /// - `htmlFormType`: The HTML form type.
  TextInputType getKeyboardType(String htmlFormType) {
    if (htmlFormType == "email") {
      return TextInputType.emailAddress;
    } else if (htmlFormType == "textarea") {
      return TextInputType.multiline;
    } else if (htmlFormType == "date") {
      return TextInputType.datetime;
    } else if (htmlFormType == "number") {
      return TextInputType.number;
    } else if (htmlFormType == "") {
      return TextInputType.none;
    } else {
      return TextInputType.text; // Default keyboardType
    }
  }

  String extractDigitsOnly(TextEditingController controller) {
    final RegExp regex = RegExp(r'[0-9]+');
    final String text = controller.text;
    final Iterable<Match> matches = regex.allMatches(text);

    if (matches.isNotEmpty) {
      final List<String> digitMatches =
          matches.map((match) => match.group(0)!).toList();
      controller.text = digitMatches.join();
    } else {
      controller.text = "";
    }
    return controller.text;
  }

  setValues() {
    widget.areaResponse.name = widget.areaResponse.name;
    widget.areaResponse.active = areaData.active;
    try {
      if (int.tryParse(refreshController.text) == null || refreshController.text.length > 6) {
        widget.areaResponse.refresh = 525600;
      } else {
        widget.areaResponse.refresh = int.parse(refreshController.text);
      }
    } catch (e) {
      widget.areaResponse.refresh = widget.areaResponse.refresh;
    }
    widget.areaResponse.actionConfig = areaData.actionConfig;
    widget.areaResponse.reactionConfig = areaData.reactionConfig;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
                width: 100, height: 100, child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          areaData = snapshot.data!;
          List<dynamic> choiceList = [];
          AreaService areaService =
              Provider.of<AreaService>(context, listen: false);
          String valueAction = "";
          String valueReaction = "";
          widget.areaResponse.actionConfig = areaData.actionConfig;
          widget.areaResponse.reactionConfig = areaData.reactionConfig;
          return FutureBuilder<List<dynamic>>(
              future: future2,
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
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: DecoratedBox(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/background.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.only(bottom: 24.0, right: 24.0),
                              child: Text("Edition de votre Area",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GlassContainerRounded(
                                    width: 460,
                                    height: 200,
                                    colorOpacity: 0.3,
                                    borderRadius: 15,
                                    borderColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SettingsAreaTopBar(
                                              item: widget.areaResponse),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Activer/désactiver",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                ToggleButtons(
                                                  renderBorder: false,
                                                  disabledBorderColor:
                                                      Colors.transparent,
                                                  selectedBorderColor:
                                                      Colors.transparent,
                                                  selectedColor:
                                                      Colors.transparent,
                                                  disabledColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  fillColor: Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  isSelected: [
                                                    widget.areaResponse.active
                                                  ],
                                                  onPressed: (int index) {
                                                    setState(() {
                                                      if (areaData.active) {
                                                        areaData.active = false;
                                                      } else {
                                                        areaData.active = true;
                                                      }
                                                      setValues();
                                                    });
                                                  },
                                                  children: [
                                                    if (areaData.active)
                                                      const Icon(
                                                        Icons
                                                            .toggle_on_outlined,
                                                        size: 40,
                                                        color: Colors.green,
                                                      )
                                                    else
                                                      const Icon(
                                                        Icons
                                                            .toggle_off_outlined,
                                                        size: 40,
                                                        color: Colors.red,
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          RefreshField(
                                              placeholder:
                                                  widget.areaResponse.refresh,
                                              controller: refreshController),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  CustomExpansionTile(
                                    title: "Action",
                                    children: [
                                      if (choiceList[0].isEmpty)
                                        const Text(
                                          "Pas de configuration supplémentaire",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var i in choiceList[0])
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 24.0),
                                              child: InputFieldLabelised(
                                                title: i.display,
                                                isRequired: i.mandatory,
                                                inputField:
                                                    GlassContainerRounded(
                                                  width: 320,
                                                  height: i.htmlFormType ==
                                                          "textarea"
                                                      ? 200
                                                      : 40,
                                                  colorOpacity: 0.5,
                                                  borderRadius: 10,
                                                  borderColor: Colors.white,
                                                  child: whichController(
                                                      i,
                                                      valueAction,
                                                      widget.areaResponse,
                                                      choiceList),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  CustomExpansionTile(
                                    title: "Réaction",
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Les variables disponibles sont:",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            InfoButton(
                                                title: "Aide :",
                                                value: transformToString(
                                                    choiceList[3])),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 360,
                                          height: 150,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: LayoutGrid(
                                              columnSizes: const [auto],
                                              rowSizes: const [
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto,
                                                auto
                                              ],
                                              rowGap: 8,
                                              columnGap: 8,
                                              children: [
                                                for (var i in choiceList[3])
                                                  ConfigOptions(
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  "{{${i["name"]}}}"));
                                                    },
                                                    text: i["name"],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          for (var i in choiceList[1])
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 24.0),
                                              child: InputFieldLabelised(
                                                title: i.display,
                                                isRequired: i.mandatory,
                                                inputField:
                                                    GlassContainerRounded(
                                                  width: 320,
                                                  height: i.htmlFormType ==
                                                          "textarea"
                                                      ? 200
                                                      : 40,
                                                  colorOpacity: 0.5,
                                                  borderRadius: 10,
                                                  borderColor: Colors.white,
                                                  child:
                                                      whichControllerReaction(
                                                          i,
                                                          valueReaction,
                                                          widget.areaResponse,
                                                          choiceList),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GlassContainerRounded(
                                    width: 320,
                                    height: 40,
                                    colorOpacity: 0.5,
                                    borderRadius: 10,
                                    borderColor: const Color(0xFF4c5af6),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // widget.areaResponse.name =
                                        //     widget.areaResponse.name;
                                        // widget.areaResponse.active =
                                        //     areaData.active;
                                        // try {
                                        //   widget.areaResponse.refresh =
                                        //       int.parse(refreshController.text);
                                        // } catch (e) {
                                        //   widget.areaResponse.refresh =
                                        //       widget.areaResponse.refresh;
                                        // }
                                        // widget.areaResponse.actionConfig =
                                        //     areaData.actionConfig;
                                        // widget.areaResponse.reactionConfig =
                                        //     areaData.reactionConfig;
                                        setValues();

                                        await areaService.updateAreaById(
                                            context, widget.areaResponse);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Sauvegarder",
                                        style: TextStyle(
                                          color: Color(0xff4c5af6),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GlassContainerRounded(
                                    width: 320,
                                    height: 40,
                                    colorOpacity: 0.5,
                                    borderRadius: 10,
                                    borderColor: const Color(0xFFb24343),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Annuler",
                                        style: TextStyle(
                                          color: Color(0xFFb24343),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              });
        }
      },
    );
  }

  Widget whichController(dynamic i, String valueAction,
      AreaResponse areaResponse, List<dynamic> choiceList) {
    List<String> parts = i.htmlFormType.split(":");
    TextEditingController controller = TextEditingController();
    if (parts.isNotEmpty && parts[0] == "select") {
      List<String> options = parts[1].split(";");
      List<Map<String, String>> items = options.map((option) {
        List<String> optionParts = option.split("|");
        if (optionParts.length == 2) {
          return {
            'value': optionParts[1],
            'name': optionParts[0],
          };
        } else {
          return {'value': '', 'name': ''};
        }
      }).toList();
      return InputFieldCustom(
        controller: TextEditingController(),
        dropdownItems: items
            .where((item) => item['name'] != null)
            .map((item) => item['name']!)
            .toList(),
        hintText: i.value,
        validator: i.mandatory
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              }
            : null,
        onChanged: (value) {
          valueAction = value;
          final selectedItem = items.firstWhere((item) => item['name'] == value,
              orElse: () => {'value': 'Valeur non trouvée'});
          final existingConfigIndex = areaResponse.actionConfig!
              .indexWhere((config) => config.name == i.name);
          if (existingConfigIndex != -1) {
            i.value = valueAction;
            areaResponse.actionConfig![existingConfigIndex].value = valueAction;
          } else {
            i.value = selectedItem['value'];
            areaResponse.actionConfig?.add(Config(
              value: selectedItem['value'],
              mandatory: i.mandatory,
              display: i.display,
              htmlFormType: i.htmlFormType,
              name: i.name,
            ));
          }
          try {
            areaResponse.actionName = choiceList[2][0];
            areaResponse.actionIcon = choiceList[2][1];
          } catch (e) {
            areaResponse.actionName = areaData.actionName;
            areaResponse.actionIcon = areaData.actionIcon;
          }
          setValues();
        },
      );
    } else {
      return InputField(
        keyboardType: i.htmlFormType == "number"
            ? TextInputType.text
            : getKeyboardType(i.htmlFormType),
        controller: controller,
        hintText: controller.text == "" ? i.value : controller.text,
        validator: i.mandatory
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              }
            : null,
        onEditingComplete: () => setState(() {
          if (i.htmlFormType == "number") {
            extractDigitsOnly(controller);
          }
          valueAction = controller.text;
          valueAction == "" ? i.value = i.value : i.value = valueAction;
          setValues();
          FocusScope.of(context).unfocus();
        }),
        onChanged: (value) {
          if (i.htmlFormType == "number") {
            extractDigitsOnly(controller);
          }
          controller.text == ""
              ? valueAction = i.value
              : valueAction = controller.text;
          final existingConfigIndex = areaResponse.actionConfig!
              .indexWhere((config) => config.name == i.name);

          if (existingConfigIndex != -1) {
            areaResponse.actionConfig![existingConfigIndex].value = valueAction;
          } else {
            areaResponse.actionConfig?.add(Config(
              value: valueAction,
              mandatory: i.mandatory,
              display: i.display,
              htmlFormType: i.htmlFormType,
              name: i.name,
            ));
          }
          try {
            areaResponse.actionName = choiceList[2][0];
            areaResponse.actionIcon = choiceList[2][1];
          } catch (e) {
            areaResponse.actionName = areaData.actionName;
            areaResponse.actionIcon = areaData.actionIcon;
          }
          setValues();
        },
      );
    }
  }

  Widget whichControllerReaction(dynamic i, String valueReaction,
      AreaResponse areaResponse, List<dynamic> choiceList) {
    List<String> parts = i.htmlFormType.split(":");
    TextEditingController controller = TextEditingController();
    if (parts.isNotEmpty && parts[0] == "select") {
      List<String> options = parts[1].split(";");
      List<Map<String, String>> items = options.map((option) {
        List<String> optionParts = option.split("|");
        if (optionParts.length == 2) {
          return {
            'value': optionParts[1],
            'name': optionParts[0],
          };
        } else {
          return {'value': '', 'name': ''};
        }
      }).toList();
      return InputFieldCustom(
        controller: controller,
        dropdownItems: items
            .where((item) => item['name'] != null)
            .map((item) => item['name']!)
            .toList(),
        hintText: i.value,
        validator: i.mandatory
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              }
            : null,
        onChanged: (value) {
          valueReaction = value;
          final selectedItem = items.firstWhere((item) => item['name'] == value,
              orElse: () => {'value': 'Valeur non trouvée'});
          print("Nom: $value, Valeur: ${selectedItem['value']}");
          final existingConfigIndex = areaResponse.reactionConfig!
              .indexWhere((config) => config.name == i.name);

          if (existingConfigIndex != -1) {
            areaResponse.reactionConfig![existingConfigIndex].value =
                valueReaction;
          } else {
            areaResponse.reactionConfig?.add(Config(
              value: selectedItem['value'],
              mandatory: i.mandatory,
              display: i.display,
              htmlFormType: i.htmlFormType,
              name: i.name,
            ));
          }
          try {
            areaResponse.reactionName = choiceList[2][2];
            areaResponse.reactionIcon = choiceList[2][3];
          } catch (e) {
            areaResponse.reactionName = areaData.reactionName;
            areaResponse.reactionIcon = areaData.reactionIcon;
          }
          setValues();
        },
      );
    } else {
      return InputField(
        keyboardType: i.htmlFormType == "number"
            ? TextInputType.text
            : getKeyboardType(i.htmlFormType),
        controller: controller,
        hintText: i.value,
        validator: i.mandatory
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              }
            : null,
        onEditingComplete: () => setState(() {
          if (i.htmlFormType == "number") {
            extractDigitsOnly(controller);
          }
          valueReaction = controller.text;
          valueReaction == "" ? i.value = i.value : i.value = valueReaction;
          setValues();
          FocusScope.of(context).unfocus();
        }),
        suffix: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {
            FocusScope.of(context).unfocus();
            controller.text != ""
                ? i.value = controller.text
                : i.value = i.value;
          },
          child: SvgPicture.asset(
            'assets/checked.svg',
            width: 20,
            height: 20,
            color: Colors.blue,
          ),
        ),
        onChanged: (value) {
          value == "" ? valueReaction = i.value : valueReaction = value;
          final existingConfigIndex = areaResponse.reactionConfig!
              .indexWhere((config) => config.name == i.name);

          if (existingConfigIndex != -1) {
            areaResponse.reactionConfig![existingConfigIndex].value =
                valueReaction;
          } else {
            areaResponse.reactionConfig?.add(Config(
              value: valueReaction,
              mandatory: i.mandatory,
              display: i.display,
              htmlFormType: i.htmlFormType,
              name: i.name,
            ));
          }
          try {
            areaResponse.reactionName = choiceList[2][2];
            areaResponse.reactionIcon = choiceList[2][3];
          } catch (e) {
            areaResponse.reactionName = areaData.reactionName;
            areaResponse.reactionIcon = areaData.reactionIcon;
          }
          setValues();
        },
      );
    }
  }
}

/// Fetch the list of areas configuration
///
/// - `context`: The context of the widget
/// - `areaService`: The area service
/// - `areaResponse`: The area response
Future<List<dynamic>> fetchAreasConfig(BuildContext context,
    AreaService areaService, AreaResponse areaResponse) async {
  final List<ServiceContent> services = await areaService.getServices(context);
  final AreaData areaContent =
      await areaService.getAreasById(context, areaResponse.id);
  List<Config> actionsConfig = [];
  List<Config> reactionsConfig = [];
  List<String> infos = [];
  List params = [];

  actionsConfig = areaContent.actionConfig;
  reactionsConfig = areaContent.reactionConfig;
  for (var service in services) {
    for (var action in service.actions) {
      if (action.name == areaResponse.actionName) {
        infos.add(action.name);
        infos.add(service.serviceIcon);
        params = (action.returnParams);
      }
    }
    for (var reaction in service.reactions) {
      if (reaction.name == areaResponse.reactionName) {
        infos.add(reaction.name);
        infos.add(service.serviceIcon);
      }
    }
  }
  infos.add(areaContent.refresh.toString());
  print("==========INFOS=============");
  print(infos);
  print("=======================");
  return [actionsConfig, reactionsConfig, infos, params];
}
