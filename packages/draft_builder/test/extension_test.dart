import 'package:test/test.dart';

import 'common.dart';
import 'integration/extension.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'extension.dart';

void main() {
  BasicWithExtension(value: 1);
  BasicWithExtension(value: 1).draft().save();
  BasicWithExtension(value: 1).produce((draft) {
    draft.value = 2;
  });
}
'''),
      completes,
    );
  });

  test('works correctly', () async {
    expect(BasicWithExtension(value: 1).draft().value, 1);
    expect(BasicWithExtension(value: 1).draft().save().value, 1);
    expect(
      BasicWithExtension(value: 1).produce((draft) {
        draft.value = 2;
      }).value,
      2,
    );

    final draft = BasicWithExtension(value: 1).draft()..value = 10;
    expect(draft.save().value, 10);
  });
}
