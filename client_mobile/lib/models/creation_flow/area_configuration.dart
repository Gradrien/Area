import 'package:client_mobile/models/area/area_content.dart';
import 'package:client_mobile/models/area/area_response.dart';
import 'package:client_mobile/models/area/config.dart';
import 'package:client_mobile/models/area/config_variable.dart';
import 'package:client_mobile/models/area/service.dart';
import 'package:client_mobile/models/helper.dart';
import 'package:client_mobile/models/input_field.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';

/// A StatefulWidget that allows users to choose configuration settings.
class ChooseConfiguration extends StatefulWidget {
  /// The current area content.
  final AreaContent areacontent;

  /// A Future that represents the area response data.
  final Future<AreaResponse> areaResponse;

  /// A callback function to update the area response.
  final Function(AreaResponse) onUpdateAreaResponse;

  /// Constructor for [ChooseConfiguration] class.
  ///
  /// - [areacontent]: The current area content.
  /// - [areaResponse]: The area response data.
  /// - [onUpdateAreaResponse]: A callback function to update the area response.
  const ChooseConfiguration(
      {super.key,
      required this.areacontent,
      required this.areaResponse,
      required this.onUpdateAreaResponse});

  @override
  State<ChooseConfiguration> createState() => _ChooseConfigurationState();
}

/// The State class for [ChooseConfiguration] class.
class _ChooseConfigurationState extends State<ChooseConfiguration> {
  /// Returns the appropriate keyboard type based on the HTML form type.
  ///
  /// [htmlFormType] - The HTML form type to determine the keyboard type.
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

  @override
  Widget build(BuildContext context) {
    AreaService areaService = Provider.of<AreaService>(context, listen: false);
    String valueAction = "";
    String valueReaction = "";
    TextEditingController textController = TextEditingController();

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        fetchAreasConfig(context, areaService, widget.areacontent.actionId,
            widget.areacontent.reactionId),
        widget.areaResponse
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
                width: 100, height: 100, child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          List<dynamic> data = snapshot.data!;
          List<dynamic> choiceList = data[0];
          AreaResponse areaResponse = data[1];
          return SizedBox(
            width: 340,
            height: 300,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 0, bottom: 24.0),
                  child: InputFieldLabelised(
                    title: "Nom",
                    inputField: GlassContainerRounded(
                      width: 320,
                      height: 50,
                      colorOpacity: 0.5,
                      borderRadius: 10,
                      borderColor: Colors.white,
                      child: InputField(
                        hintText: "Nom de l'area",
                        controller: TextEditingController(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          areaResponse.name = value;
                        },
                      ),
                    ),
                  ),
                ),
                RefreshField(
                  onChanged: (value) {
                    try {
                      if (int.tryParse(textController.text) == null || textController.text.length > 6) {
                        areaResponse.refresh = 525600;
                      } else {
                        areaResponse.refresh =
                            int.parse(textController.text);
                      }
                      print(areaResponse.refresh);
                    } catch (e) {
                      areaResponse.refresh = areaResponse.refresh;
                    }
                  },
                  placeholder: areaResponse.refresh,
                  controller: textController,
                ),
                const SizedBox(height: 24),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i in choiceList[0])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: InputFieldLabelised(
                              title: i.display,
                              isRequired: i.mandatory,
                              inputField: GlassContainerRounded(
                                width: 320,
                                height: i.htmlFormType == "textarea" ? 200 : 40,
                                colorOpacity: 0.5,
                                borderRadius: 10,
                                borderColor: Colors.white,
                                child: whichController(
                                    i, valueAction, areaResponse, choiceList),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomExpansionTile(
                  title: "Réaction",
                  children: [
                    if (choiceList[1].isEmpty)
                      const Text(
                        "Pas de configuration supplémentaire",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    if (choiceList[1].isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                value: transformToString(choiceList[3])),
                          ],
                        ),
                      ),
                    if (choiceList[1].isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                    Clipboard.setData(ClipboardData(
                                        text: "{{${i["name"]}}}"));
                                  },
                                  text: i["name"],
                                ),
                            ],
                          ),
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i in choiceList[1])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: InputFieldLabelised(
                              title: i.display,
                              isRequired: i.mandatory,
                              inputField: GlassContainerRounded(
                                width: 320,
                                height: i.htmlFormType == "textarea" ? 200 : 40,
                                colorOpacity: 0.5,
                                borderRadius: 10,
                                borderColor: Colors.white,
                                child: whichControllerReaction(
                                    i, valueReaction, areaResponse, choiceList),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget whichController(dynamic i, String valueAction,
      AreaResponse areaResponse, List<dynamic> choiceList) {
    List<String> parts = i.htmlFormType.split(":");
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
        hintText: "Selection",
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
          print("Nom: $value, Valeur: ${selectedItem['value']}");
          final existingConfigIndex = areaResponse.actionConfig!
              .indexWhere((config) => config.name == i.name);
          if (existingConfigIndex != -1) {
            areaResponse.actionConfig![existingConfigIndex].value = valueAction;
          } else {
            areaResponse.actionConfig?.add(Config(
              value: selectedItem['value'],
              mandatory: i.mandatory,
              display: i.display,
              htmlFormType: i.htmlFormType,
              name: i.name,
            ));
          }
          areaResponse.actionName = choiceList[2][0];
          areaResponse.actionIcon = choiceList[2][1];
        },
      );
    } else {
      return InputField(
        keyboardType: getKeyboardType(i.htmlFormType),
        controller: TextEditingController(),
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
          areaResponse.actionName = choiceList[2][0];
          areaResponse.actionIcon = choiceList[2][1];
        },
      );
    }
  }

  Widget whichControllerReaction(dynamic i, String valueReaction,
      AreaResponse areaResponse, List<dynamic> choiceList) {
    List<String> parts = i.htmlFormType.split(":");
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
        hintText: "Selection",
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
          areaResponse.reactionName = choiceList[2][2];
          areaResponse.reactionIcon = choiceList[2][3];
        },
      );
    } else {
      return InputField(
        controller: TextEditingController(),
        keyboardType: getKeyboardType(i.htmlFormType),
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
          areaResponse.reactionName = choiceList[2][2];
          areaResponse.reactionIcon = choiceList[2][3];
        },
      );
    }
  }
}

/// Represents a labelled input field
class InputFieldLabelised extends StatelessWidget {
  /// The title of the input field
  final String title;

  /// Widget to display in the input field
  final Widget inputField;

  /// Whether the input field is mandatory
  final bool isRequired;

  /// Constructor for the input [InputFieldLabelised] widget.
  ///
  /// - [title]: The title of the input field.
  /// - [inputField]: The widget to display in the input field.
  /// - [isRequired]: Whether the input field is mandatory. By default, it is false.
  const InputFieldLabelised({
    super.key,
    required this.title,
    required this.inputField,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (isRequired)
                        const Text(
                          " *",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        inputField,
      ],
    );
  }
}

/// A custom implementation of an Expansion Tile widget.
class CustomExpansionTile extends StatefulWidget {
  /// The title of the expansion tile.
  final String title;

  /// A list of widgets to display in the expansion tile.
  final List<Widget> children;

  /// Constructor for the [CustomExpansionTile] widget.
  ///
  /// - [title]: The title of the expansion tile.
  /// - [children]: The list of widgets to display in the expansion tile.
  const CustomExpansionTile(
      {super.key, required this.title, required this.children});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTile();
}

/// The state of the [CustomExpansionTile] widget.
class _CustomExpansionTile extends State<CustomExpansionTile> {
  /// Whether the expansion tile is expanded.
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(
            color: Colors.white.withOpacity(0.8),
            width: 1.0,
            style: BorderStyle.solid)),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      width: 340,
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        collapsedIconColor: Colors.black,
        iconColor: Colors.black,
        textColor: Colors.black,
        trailing: Icon(
          _customTileExpanded
              ? Icons.expand_more_rounded
              : Icons.navigate_next_rounded,
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _customTileExpanded = expanded;
          });
        },
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        collapsedBackgroundColor: Colors.white.withOpacity(0.3),
        backgroundColor: Colors.white.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: widget.children,
      ),
    );
  }
}

/// A widget that displays a refresh field.
class RefreshField extends StatelessWidget {
  /// The placeholder value.
  final int placeholder;

  /// The controller for the text field.
  TextEditingController controller;

  /// A callback function that is called when the text field value changes.
  final Function(String)? onChanged;

  /// Constructor for the [RefreshField] widget.
  ///
  /// - [placeholder]: The placeholder value.
  /// - [onChanged]: A callback function that is called when the text field value changes.
  /// - [controller]: The controller for the text field.
  RefreshField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Actualisation toutes les",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 80,
          height: 50,
          child: GlassContainerRounded(
            width: 80,
            height: 50,
            colorOpacity: 0.5,
            borderRadius: 15,
            borderColor: Colors.white,
            child: InputField(
              onChanged: onChanged,
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              hintText: '$placeholder',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nombre';
                }
                return null;
              },
            ),
          ),
        ),
        const Text(
          "min",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

Future<List<dynamic>> fetchAreasConfig(BuildContext context,
    AreaService areaService, int? choseA, int? choseR) async {
  final List<ServiceContent> services = await areaService.getServices(context);
  List<Config> actionsConfig = [];
  List<Config> reactionsConfig = [];
  List<String> infos = [];
  List params = [];

  for (var service in services) {
    for (var action in service.actions) {
      if (action.id == choseA) {
        infos.add(action.name);
        infos.add(service.serviceIcon);
        params = (action.returnParams);
        for (var i in action.defaultConfig) {
          actionsConfig.add(i);
        }
      }
    }
    for (var reaction in service.reactions) {
      if (reaction.id == choseR) {
        infos.add(reaction.name);
        infos.add(service.serviceIcon);
        for (var i in reaction.defaultConfig) {
          reactionsConfig.add(i);
        }
      }
    }
  }
  return [actionsConfig, reactionsConfig, infos, params];
}

/// Transforms a list of data into a formatted string.
///
/// [list] : The list of data.
String transformToString(List list) {
  String result = "";
  int i = 0;
  String temp = "";

  for (var item in list) {
    item.forEach((key, value) {
      if (i % 2 == 0) {
        temp = "$value";
      } else {
        result += "'$value' : $temp\n";
      }
      i++;
    });
    result += "\n";
  }
  return result;
}
