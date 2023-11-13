import 'package:client_mobile/models/area/area_content.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client_mobile/models/area/config.dart';

void main() {
  group('AreaData', () {
    test('Test de la fonction fromJson', () {
      final json = {
        'name': 'TestArea',
        'active': true,
        'action_name': 'TestAction',
        'action_config': [
          {
            'name': 'Config1',
            'value': 'Value1',
            'display': 'Display1',
            'mandatory': true,
            'htmlFormType': 'Type1',
          },
        ],
        'reaction_name': 'TestReaction',
        'reaction_config': [
          {
            'name': 'Config2',
            'value': 'Value2',
            'display': 'Display2',
            'mandatory': true,
            'htmlFormType': 'Type2',
          },
        ],
        'action_icon': 'action_icon.png',
        'reaction_icon': 'reaction_icon.png',
        'id': 1,
        'refresh': 10,
      };
      final areaData = AreaData.fromJson(json);
      expect(areaData.name, equals('TestArea'));
      expect(areaData.active, equals(true));
      expect(areaData.actionName, equals('TestAction'));
      expect(areaData.actionConfig, isA<List<Config>>());
      expect(areaData.actionConfig.length, equals(1)); 
      expect(areaData.reactionName, equals('TestReaction'));
      expect(areaData.reactionConfig, isA<List<Config>>());
      expect(areaData.reactionConfig.length, equals(1));
      expect(areaData.reactionIcon, equals('reaction_icon.png'));
      expect(areaData.id, equals(1));
      expect(areaData.refresh, equals(10));
    });
  });
}
