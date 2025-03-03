import 'package:test/test.dart';

import 'common.dart';
import 'integration/basic.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'basic.dart';

void main() {
  BasicInt(value: 1);
  BasicInt(value: 1).draft().save();
  BasicInt(value: 1).produce((draft) {
    draft.value = 2;
  });
}
'''),
      completes,
    );
  });

  test('works correctly', () async {
    expect(BasicInt(value: 1).draft().value, 1);
    expect(BasicInt(value: 1).draft().save().value, 1);
    expect(
      BasicInt(value: 1).produce((draft) {
        draft.value = 2;
      }).value,
      2,
    );

    final draft = BasicInt(value: 1).draft()..value = 10;
    expect(draft.save().value, 10);
  });
}
