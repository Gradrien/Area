import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:client_mobile/models/area/reaction.dart';
import 'package:client_mobile/models/area/config.dart';

void main() {
  group('Reaction', () {
    test('Test de la fonction fromJson', () {
      final json = {
        'id': 1,
        'name': 'TestReaction',
        'api_endpoint': 'https://example.com/api',
        'params': jsonEncode({'param1': 'value1', 'param2': 'value2'}),
        'default_config': jsonEncode([
          {
            'name': 'Config1',
            'value': 'Value1',
            'display': 'Display1',
            'mandatory': true,
            'htmlFormType': 'Type1',
          },
          {
            'name': 'Config2',
            'value': 'Value2',
            'display': 'Display2',
            'mandatory': true,
            'htmlFormType': 'Type2',
          },
        ]),
        'service_id': 2,
      };
      final reaction = Reaction.fromJson(json);
      expect(reaction.id, equals(1));
      expect(reaction.name, equals('TestReaction'));
      expect(reaction.apiEndpoint, equals('https://example.com/api'));
      expect(reaction.params, isA<Map<String, dynamic>>());
      expect(reaction.params, equals({'param1': 'value1', 'param2': 'value2'}));
      expect(reaction.defaultConfig, isA<List<Config>>());
      expect(reaction.defaultConfig.length, equals(2));
      expect(reaction.serviceId, equals(2));
    });
  });
}
