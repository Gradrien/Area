import 'package:client_mobile/models/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Button widget test', (WidgetTester tester) async {
    onPressed() => {};
    const String buttonText = 'Click Me';
    final ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.blue),
      textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white)),
    );

    await tester.pumpWidget(MaterialApp(
      home: Button(
        onPressed: onPressed,
        text: buttonText,
        style: buttonStyle,
      ),
    ));

    final elevatedButtonFinder = find.byType(ElevatedButton);
    expect(elevatedButtonFinder, findsOneWidget);
    final elevatedButtonWidget = tester.widget(elevatedButtonFinder) as ElevatedButton;
    expect(elevatedButtonWidget.onPressed, onPressed);
    final buttonTextFinder = find.text(buttonText);
    expect(buttonTextFinder, findsOneWidget);
    final buttonTextWidget = tester.widget(buttonTextFinder) as Text;
    expect(buttonTextWidget.style, const TextStyle(fontSize: 16, fontWeight: FontWeight.normal));
    expect(elevatedButtonWidget.style, buttonStyle);
  });
}
