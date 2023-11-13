import 'package:client_mobile/models/area/config_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test du widget ConfigOptions', (WidgetTester tester) async {
    final configOptions = ConfigOptions(
      onPressed: () {},
      text: 'Test Button',
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: configOptions)));

    final elevatedButtonFinder = find.byType(ElevatedButton);
    expect(elevatedButtonFinder, findsOneWidget);

    final textFinder = find.text('Test Button');
    expect(textFinder, findsOneWidget);

    final buttonWidget = tester.widget<ElevatedButton>(elevatedButtonFinder);
    expect(buttonWidget.enabled, isTrue);
  });
}
