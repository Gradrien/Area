import 'package:client_mobile/models/area/action.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Action', () {
    test('Test de la fonction fromJson', () {
      final json = {
        'id': 1,
        'name': 'TestAction',
        'api_endpoint': 'https://example.com',
        'return_params': '[]',
        'default_config': '[]',
        'service_id': 2,
      };
      final action = Action.fromJson(json);
      expect(action.id, equals(1));
      expect(action.name, equals('TestAction'));
      expect(action.apiEndpoint, equals('https://example.com'));
      expect(action.returnParams, isEmpty);
      expect(action.defaultConfig, isEmpty);
      expect(action.serviceId, equals(2));
    });
  });
}
