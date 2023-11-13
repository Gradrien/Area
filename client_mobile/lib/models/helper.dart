import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String value1 = "Ici vous pouvez choisir la première partie de votre Area : l'action.\nL'action est l'élément déclencheur de votre Area.\nLes actions qui vous sont proposées sont uniquement celles liées aux services pour lesquels vous êtes authentifiés.";
const String value2 = "Ici vous pouvez choisir la seconde partie de votre Area : la réaction.\nLa réaction est exécutée quand l'action est considérée comme remplie.\nLes réactions qui vous sont proposées sont uniquement celles liées aux services pour lesquels vous êtes authentifiés.";
const String value3 = "Ici vous pouvez choisir les paramètres de votre Area.\nDans un premier temps vous pouvez choisir le nom de votre Area ainsi que la fréquence à laquelle l'Area sera vérifiée.\nEnsuite vous pouvez configurer plus spécifiquement votre action et votre réaction, pour votre réaction vous pouvez utiliser les variables disponibles selon l'action que vous avez sélectionné.";

/// This widget displays a dialog box with a title and text.
class TextDialog extends StatelessWidget {
  /// The title of the dialog box.
  final String textTitle;
  /// The text of the dialog box.
  final String text;

  /// Constructor for `TextDialog` widget.
  const TextDialog({super.key, required this.textTitle, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(textTitle),
      content: Text(text),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}

/// Displays a dialog box with a title and text.
/// 
/// - [context] : The [BuildContext] of the widget.
/// - [textTitle] : The title of the dialog box.
/// - [text] : The text of the dialog box.
void showTextDialog(BuildContext context, String textTitle, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TextDialog(textTitle: textTitle, text: text);
    },
  );
}


/// This widget displays an information button that, when clicked, shows a dialog with additional information.
class InfoButton extends StatelessWidget {
  /// The title of the information button.
  final String title;
  /// The text of the information button.
  final String value;

  /// Constructor for `InfoButton` widget.
  /// 
  /// - `title` : The title of the information button.
  /// - `value` : The text of the information button.
  const InfoButton({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showTextDialog(context, title, value);
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
      ),
      child: SvgPicture.asset(
        'assets/info.svg',
        height: 32,
        width: 32,
      )
    );
  }
}

/// Class to choose which information button to use
class ConditionalInfoButton extends StatelessWidget {
  /// The current step of the area flow.
  final int currentStep;

  /// Constructor for [ConditionalInfoButton] widget.
  /// 
  /// - [currentStep] : The current step of the area flow.
  const ConditionalInfoButton({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildInfoButton(currentStep),
        ],
      ),
    );
  }

  Widget _buildInfoButton(int step) {
    if (step == 0) {
      return const InfoButton(title: "Aide :", value: value1);
    } else if (step == 1) {
      return const InfoButton(title: "Aide: ", value: value2);
    } else if (step == 2) {
      return const InfoButton(title: "Aide: ", value: value3);
    } else {
      return Container();
    }
  }
}
