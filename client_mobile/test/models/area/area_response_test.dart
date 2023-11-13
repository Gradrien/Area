import 'dart:convert';

import 'package:client_mobile/models/area/area_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client_mobile/models/area/config.dart';

void main() {
  group('AreaResponse', () {
    test('Test de la fonction fromJson', () {
      final json = {
        'name': 'TestArea',
        'action_name': 'TestAction',
        'action_config': jsonEncode([
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
        'reaction_name': 'TestReaction',
        'reaction_config': jsonEncode([
          {
            'name': 'Config3',
            'value': 'Value3',
            'display': 'Display3',
            'mandatory': true,
            'htmlFormType': 'Type3',
          },
          {
            'name': 'Config4',
            'value': 'Value4',
            'display': 'Display4',
            'mandatory': true,
            'htmlFormType': 'Type4',
          },
        ]),
        'action_icon': 'action_icon.png',
        'reaction_icon': 'reaction_icon.png',
        'id': 1,
        'refresh': 10,
        'active': true,
      };
      final areaResponse = AreaResponse.fromJson(json);
      expect(areaResponse.name, equals('TestArea'));
      expect(areaResponse.actionName, equals('TestAction'));
      expect(areaResponse.actionConfig, isA<List<Config>>());
      expect(areaResponse.actionConfig?.length, equals(2));
      expect(areaResponse.reactionConfig, isA<List<Config>>());
      expect(areaResponse.reactionConfig?.length, equals(2));
      expect(areaResponse.actionIcon, equals('action_icon.png'));
      expect(areaResponse.reactionIcon, equals('reaction_icon.png'));
      expect(areaResponse.id, equals(1));
      expect(areaResponse.refresh, equals(10));
      expect(areaResponse.active, equals(true));
    });
  });
}
