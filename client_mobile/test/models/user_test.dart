import 'package:client_mobile/models/user.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('fromJson should create a User instance from a JSON map', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'created_at': '2023-10-26T12:00:00Z',
      };

      final User user = User.fromJson(json);

      expect(user.id, equals(1));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john.doe@example.com'));
      expect(user.created, equals('2023-10-26T12:00:00Z'));
    });

    test('getName should return the user name', () {
      final User user = User(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        created: '2023-10-26T12:00:00Z',
      );

      expect(user.getName, equals('John Doe'));
    });

    test('getEmail should return the user email', () {
      final User user = User(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        created: '2023-10-26T12:00:00Z',
      );

      expect(user.getEmail, equals('john.doe@example.com'));
    });
  });
}
