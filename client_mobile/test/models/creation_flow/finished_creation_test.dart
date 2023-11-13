import 'package:client_mobile/models/creation_flow/finished_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FinishedCreation widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: FinishedCreation(),
    ));
    final svgPictureFinder = find.byType(SvgPicture);
    expect(svgPictureFinder, findsOneWidget);
    final svgPictureWidget = tester.widget(svgPictureFinder) as SvgPicture;
    expect(svgPictureWidget.height, 128);
    expect(svgPictureWidget.width, 128);
  });
}
