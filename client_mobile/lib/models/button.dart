
import 'package:flutter/material.dart';

/// A custom button widget.
class Button extends StatelessWidget {
  /// A callback function that is called when the button is pressed.
  final VoidCallback onPressed;
  /// The text to display on the button.
  final String text;
  /// The style of the button.
  final ButtonStyle style;

  /// Constructor for the `Button` widget.
  /// 
  /// - `onPressed` - A callback function that is called when the button is pressed.
  /// - `text` - The text to display on the button.
  /// - `style` - The style of the button.
  const Button({super.key, required this.onPressed, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
      );
  }
}