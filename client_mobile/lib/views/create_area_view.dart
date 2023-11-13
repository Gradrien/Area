import 'package:client_mobile/models/area/area_content.dart';
import 'package:client_mobile/models/area/area_response.dart';
import 'package:client_mobile/models/creation_flow/area_configuration.dart';
import 'package:client_mobile/models/creation_flow/action_reaction_choice.dart';
import 'package:client_mobile/models/creation_flow/finished_creation.dart';
import 'package:client_mobile/models/creation_flow/new_area_container.dart';
import 'package:client_mobile/models/helper.dart';
import 'package:client_mobile/nav/nav.dart';
import 'package:client_mobile/router/route_utils.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:client_mobile/services/auth_services.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';
import 'package:client_mobile/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// View for creating an area.
class CreateAreaView extends StatefulWidget {
  /// Constructor for `CreateAreaView` widget.
  /// 
  const CreateAreaView({Key? key}) : super(key: key);

  @override
  State<CreateAreaView> createState() => _CreateAreaViewState();
}

/// State for `CreateAreaView` widget.
class _CreateAreaViewState extends State<CreateAreaView> {
  /// The content of the area.
  AreaContent areaContent = AreaContent();
  /// The default response of the area creation.
  late AreaResponse areaResponse = AreaResponse(
      id: -1,
      name: '',
      actionName: '',
      reactionName: '',
      active: false,
      actionIcon: '',
      reactionIcon: '',
      refresh: 1);
  /// The current step of the area creation.
  int currentStep = 0;
  /// The list of widgets for each step of the area creation.
  late List<Widget> areaStep;
  /// The widget for the current step of the area creation.
  late Widget currentAreaStep = areaStep[0];

  @override
  void initState() {
    super.initState();
    areaResponse.actionConfig = [];
    areaResponse.reactionConfig = [];
    areaContent.refresh = 1;
  }

  /// List of Titles for each step of the area creation.
  final List<String> areaStepTitle = [
    "Choisir une action",
    "Choisir une réaction",
    "Configurer son Area",
    "Terminé",
  ];
  /// Actual Title of the current step of the area creation.
  String currentAreaStepTitle = "Choisir une action";
  /// Error message for the current step of the area creation.
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    areaStep = [
      SelectAreaAction(areacontent: areaContent),
      SelectAreaReaction(areacontent: areaContent),
      ChooseConfiguration(
        areacontent: areaContent,
        areaResponse: Future.value(areaResponse),
        onUpdateAreaResponse: (updatedAreaResponse) {
          setState(() {
            areaResponse = updatedAreaResponse;
          });
        },
      ),
      const FinishedCreation(),
      const FinishedCreation(),
    ];
    final areaService = Provider.of<AreaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    Future<void> handleStepChange(int currentStep) async {
      if (currentStep == 2) {
        if (areaResponse.id == -1) {
          areaResponse = await areaService.createArea(context, areaContent);
        }
        final chooseConfigWidget = ChooseConfiguration(
          areacontent: areaContent,
          areaResponse: Future.value(areaResponse),
          onUpdateAreaResponse: (updatedAreaResponse) {
            setState(() {
              areaResponse = updatedAreaResponse;
            });
          },
        );

        setState(() {
          areaStep[2] = chooseConfigWidget;
        });
      }
      if (currentStep == 3) {
        final bool result = await areaService.updateAreaById(context, areaResponse);
        if (result) {
          await authService.startArea(areaResponse.id);
        }
      }
      if (currentStep == 4) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Nav()));
      }
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Nouvelle Area",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currentAreaStepTitle,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ConditionalInfoButton(currentStep: currentStep),
                    ],
                  ),
                ),
                NewAreaContainer(
                  areacontent: areaContent,
                  child: areaStep[currentStep],
                  onStepChanged: () async {
                    setState(() {
                      if (currentStep == 0 && areaContent.actionId == null) {
                        errorMessage = 'Veuillez choisir une action';
                        return;
                      } else if (currentStep == 1 &&
                          areaContent.reactionId == null) {
                        errorMessage = 'Veuillez choisir une réaction';
                        return;
                      } else if (currentStep == 2) {
                        bool hasEmptyMandatoryFields = false;
                        hasEmptyMandatoryFields =
                            checkMandatoryField(areaResponse);
                        if (hasEmptyMandatoryFields) {
                          errorMessage =
                              'Veuillez remplir tous les champs obligatoires';
                          return;
                        }
                        errorMessage = '';
                      } else {
                        errorMessage = '';
                      }
                      if (currentStep < areaStep.length - 1) {
                        currentStep++;
                      }
                      if (currentStep < areaStep.length - 1) {
                        currentAreaStepTitle = areaStepTitle[currentStep];
                      }
                    });
                    await handleStepChange(currentStep);
                  },
                ),
                const SizedBox(height: 40),
                errorMessage.isNotEmpty
                    ? GlassContainerRounded(
                        colorOpacity: 0.5,
                        borderColor: Colors.red,
                        width: 360,
                        height: 40,
                        borderRadius: 15,
                        padding: const EdgeInsets.all(3),
                        child: Center(
                          child: Text(errorMessage,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < areaStep.length - 1; i++)
                      i <= currentStep
                          ? const Icon(Icons.fiber_manual_record,
                              size: 20, color: Color(0xFF4C5AF6))
                          : const Icon(
                              Icons.fiber_manual_record_outlined,
                              size: 20,
                              color: Color(0xFF4C5AF6),
                            )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Check if all mandatory fields are filled.
/// 
/// - `areaResponse`: The area response to check.
bool checkMandatoryField(AreaResponse areaResponse) {
  bool checker = false;
  if (areaResponse.actionConfig != null) {
    for (final config in areaResponse.actionConfig!) {
      if (config.mandatory && config.value == "") {
        checker = true;
        return true;
      }
    }
  }
  if (!checker && areaResponse.reactionConfig != null) {
    for (final config in areaResponse.reactionConfig!) {
      if (config.mandatory && config.value == "") {
        return true;
      }
    }
  }
  return false;
}
