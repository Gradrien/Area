import 'package:flutter_test/flutter_test.dart';
import 'package:client_mobile/models/area/service.dart';

void main() {
  group('Service', () {
    test('Test de la fonction fromJson', () {
      final json = {
        'id': 1,
        'name': 'TestService',
        'is_enabled': true,
        'service_icon': 'service_icon.png',
      };
      final service = Service.fromJson(json);
      expect(service.id, equals(1));
      expect(service.name, equals('TestService'));
      expect(service.isEnabled, equals(true));
      expect(service.serviceIcon, equals('service_icon.png'));
    });
  });
}
