import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This widget is for creating a standard input field with various properties.
// ignore: must_be_immutable
class InputField extends StatefulWidget {
  /// The controller for the input field.
  final TextEditingController controller;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// The hint text for the input field.
  final String? hintText;

  /// The label text for the input field.
  final String? labelText;

  /// Whether the input field is obscured.
  bool obscureText;

  /// A function to validate the input text.
  final String? Function(String?)? validator;

  /// A list of input formatters to format the input text.
  final List<TextInputFormatter>? inputFormatters;

  /// A callback function to handle text changes.
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  Widget? suffix;

  /// Constructor for the `InputField` widget.
  ///
  /// - `controller`: The controller for the input field.
  /// - `keyboardType`: The type of keyboard to display.
  /// - `hintText`: The hint text for the input field.
  /// - `labelText`: The label text for the input field.
  /// - `obscureText`: Whether the input field is obscured.
  /// - `validator`: A function to validate the input text.
  /// - `inputFormatters`: A list of input formatters to format the input text.
  /// - `onChanged`: A callback function to handle text changes.
  InputField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.hintText,
    this.labelText,
    this.validator,
    this.obscureText = false,
    this.inputFormatters,
    this.onChanged,
    this.onEditingComplete,
    this.suffix,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

/// The state for the [InputField] widget.
class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    if (widget.keyboardType == TextInputType.multiline) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             if (widget.keyboardType == TextInputType.multiline &&
                widget.suffix != null && FocusScope.of(context).hasFocus)
              widget.suffix!,
            TextFormField(
              onEditingComplete: widget.onEditingComplete,
              controller: widget.controller,
              validator: widget.validator,
              onChanged: widget.onChanged,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              textDirection: TextDirection.ltr,
              maxLines: widget.keyboardType == TextInputType.multiline ? 30 : 1,
              style: const TextStyle(
                color: Color.fromARGB(255, 133, 133, 133),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: widget.labelText,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: widget.hintText,
              ),
            ),
          ],
        ),
      );
    } else {
      return TextFormField(
        onEditingComplete: widget.onEditingComplete,
        controller: widget.controller,
        // textInputAction: TextInputAction.newline,
        validator: widget.validator,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        textDirection: TextDirection.ltr,
        maxLines: widget.keyboardType == TextInputType.multiline ? 30 : 1,
        style: const TextStyle(
          color: Color.fromARGB(255, 133, 133, 133),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: widget.labelText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          hintText: widget.hintText,
        ),
      );
    }
  }
}

/// This widget is for creating a custom input field with dropdown options.
class InputFieldCustom extends StatefulWidget {
  /// The controller for the input field.
  final TextEditingController controller;

  /// A list of dropdown items.
  final List<String> dropdownItems;

  /// The label text for the input field.
  final String? labelText;

  /// The hint text for the input field.
  String? hintText;

  /// A function to validate the selected value.
  final String? Function(String?)? validator;

  /// A callback function to handle value changes.
  final void Function(String)? onChanged;

  /// Constructor for the `InputFieldCustom` widget.
  ///
  /// - `controller`: The controller for the input field.
  /// - `dropdownItems`: A list of dropdown items.
  /// - `labelText`: The label text for the input field.
  /// - `hintText`: The hint text for the input field.
  /// - `validator`: A function to validate the selected value.
  /// - `onChanged`: A callback function to handle value changes.
  InputFieldCustom({
    super.key,
    required this.controller,
    required this.dropdownItems,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
  });

  @override
  _InputFieldCustomState createState() => _InputFieldCustomState();
}

/// The state for the [InputFieldCustom] widget.
class _InputFieldCustomState extends State<InputFieldCustom> {
  /// The selected value on the dropdown menu.
  String? selectedValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: Text(widget.hintText!),
      value: selectedValue,
      items: widget.dropdownItems.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
          if (widget.onChanged != null) {
            widget.onChanged!(newValue!);
            selectedValue = newValue;
          }
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        hintText: widget.hintText,
      ),
      validator: widget.validator,
    );
  }
}
