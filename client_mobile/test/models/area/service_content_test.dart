import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:client_mobile/models/area/service.dart';
import 'package:client_mobile/models/area/action.dart';
import 'package:client_mobile/models/area/reaction.dart';

void main() {
  group('ServiceContent', () {
    test('Test de la fonction fromJson', () {
      final json = {
        'id': 1,
        'name': 'TestServiceContent',
        'api_endpoint': 'https://example.com/api',
        'is_enabled': true,
        'service_icon': 'service_icon.png',
        'actions': [
          {
            'id': 1,
            'name': 'Action1',
            'api_endpoint': 'https://example.com/action1',
            'return_params': '[]',
            'default_config': '[]',
            'service_id': 1,
          },
          {
            'id': 2,
            'name': 'Action2',
            'api_endpoint': 'https://example.com/action2',
            'return_params': '[]',
            'default_config': '[]',
            'service_id': 2,
          },
        ],
        'reactions': [
          {
            'id': 1,
            'name': 'Reaction1',
            'api_endpoint': 'https://example.com/reaction1',
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
            'service_id': 1,
          },
          {
            'id': 2,
            'name': 'Reaction2',
            'api_endpoint': 'https://example.com/reaction2',
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
          },
        ],
      };
      final serviceContent = ServiceContent.fromJson(json);
      expect(serviceContent.id, equals(1));
      expect(serviceContent.name, equals('TestServiceContent'));
      expect(serviceContent.apiEndpoint, equals('https://example.com/api'));
      expect(serviceContent.isEnabled, equals(true));
      expect(serviceContent.serviceIcon, equals('service_icon.png'));
      expect(serviceContent.actions, isA<List<Action>>());
      expect(serviceContent.actions.length, equals(2));
      expect(serviceContent.reactions, isA<List<Reaction>>());
      expect(serviceContent.reactions.length, equals(2));

      expect(serviceContent.reactions[0].params, equals({'param1': 'value1', 'param2': 'value2'}));
      expect(serviceContent.reactions[1].params, equals({'param1': 'value1', 'param2': 'value2'}));
      expect(serviceContent.actions[0].name, equals('Action1'));
      expect(serviceContent.actions[1].name, equals('Action2'));
    });
  });
}
