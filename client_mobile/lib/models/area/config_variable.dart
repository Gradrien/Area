import 'package:flutter/material.dart';

/// A configurable option widget that can trigger a callback when pressed.
class ConfigOptions extends StatelessWidget {
  /// The callback function to execute when the option is pressed.
  final VoidCallback onPressed;
  /// The text to display on the option.
  final String text;

  /// Constructor for the `ConfigOptions` class.
  ///
  /// - `onPressed`: The callback function to execute when the option is pressed.
  /// - `text`: The text to display on the option.
  const ConfigOptions({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black , fontWeight: FontWeight.normal),),
        ),
    );
  }
}