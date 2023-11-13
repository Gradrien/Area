import 'package:flutter_test/flutter_test.dart';
import 'package:client_mobile/models/area/config.dart';

void main() {
  test('Test de la fonction toJson', () {
    final config = Config(
      name: 'TestConfig',
      value: 'TestValue',
      display: 'TestDisplay',
      mandatory: true,
      htmlFormType: 'text',
    );
    final json = config.toJson();
    expect(json, equals({
      'name': 'TestConfig',
      'value': 'TestValue',
      'display': 'TestDisplay',
      'mandatory': true,
      'htmlFormType': 'text',
    }));
  });

  test('Test de la fonction fromJson', () {
    final json = {
      'name': 'TestConfig',
      'value': 'TestValue',
      'display': 'TestDisplay',
      'mandatory': true,
      'htmlFormType': 'text',
    };
    final config = Config.fromJson(json);
    expect(config.name, equals('TestConfig'));
    expect(config.value, equals('TestValue'));
    expect(config.display, equals('TestDisplay'));
    expect(config.mandatory, isTrue);
    expect(config.htmlFormType, equals('text'));
  });

  test('Test de la fonction valueSet', () {
    final config = Config(
      name: 'TestConfig',
      display: 'TestDisplay',
      mandatory: true,
      htmlFormType: 'text',
    );
    config.valueSet = 'TestValue';
    expect(config.value, equals('TestValue'));
  });
}
