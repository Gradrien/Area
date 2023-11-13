import 'package:flutter/material.dart';

/// A widget that displays editable text.
class MyEditableText extends StatefulWidget {
  /// The initial text to display.
  String initialText;
  /// A callback function that is called when the text is changed.
  Function(String) onChanged;

  /// Constructor for the `MyEditableText` widget.
  /// 
  /// - `initialText`: The initial text to display.
  /// - `onChanged`: A callback function that is called when the text is changed.
  MyEditableText({super.key, required this.initialText, required this.onChanged});

  @override
  State<MyEditableText> createState() => _MyEditableTextState();
}

/// State class for the [MyEditableText] widget.
class _MyEditableTextState extends State<MyEditableText> {
  /// Whether the text is editable or not.
  bool isEditing = false;
  /// The controller for the text editing.
  late TextEditingController _editingController;
  /// The text to display.
  late String editedText;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.initialText);
    editedText = widget.initialText;
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void _stopEditing() {
    setState(() {
      isEditing = false;
    });
    widget.initialText = editedText;
  }

  void _handleSubmitted(String newText) {
    setState(() {
      editedText = newText;
    });
    _stopEditing();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startEditing();
      },
      child: SizedBox(
        width: 180,
        child: isEditing
            ? TextField(
                controller: _editingController,
                onSubmitted: _handleSubmitted,
                onChanged: widget.onChanged,
              )
            : Text(
                editedText,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}