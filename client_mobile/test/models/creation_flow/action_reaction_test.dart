import 'package:client_mobile/models/creation_flow/action_reaction_choice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';


void main() {
  test('ActionArea class test', () {
    final actionArea = ActionArea(
      id: 1,
      actionId: 2,
      service: 'TestService',
      name: 'TestAction',
      icon: SvgPicture.asset('test_icon.svg'),
      action: [],
    );

    expect(actionArea.id, equals(1));
    expect(actionArea.actionId, equals(2));
    expect(actionArea.service, equals('TestService'));
    expect(actionArea.name, equals('TestAction'));
  });

  test('ReactionArea class test', () {
    final reactionArea = ReactionArea(
      id: 1,
      reactionId: 2,
      service: 'TestService',
      name: 'TestReaction',
      icon: SvgPicture.asset('test_icon.svg'),
      reaction: [],
    );

    expect(reactionArea.id, equals(1));
    expect(reactionArea.reactionId, equals(2));
    expect(reactionArea.service, equals('TestService'));
    expect(reactionArea.name, equals('TestReaction'));
  });
}
