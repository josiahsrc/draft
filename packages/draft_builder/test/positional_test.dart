import 'package:test/test.dart';

import 'common.dart';
import 'integration/positional.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'positional.dart';

void main() {
  PositionalInts(1, 2);
  PositionalInts(1, 2).draft().save();
  PositionalInts(1, 2).produce((draft) {
    draft.value1 = 2;
    draft.value2 = 3;
  });
}
'''),
      completes,
    );
  });

  test('works correctly', () async {
    expect(PositionalInts(1, 2).draft().value1, 1);
    expect(PositionalInts(1, 2).draft().value2, 2);
    expect(
      PositionalInts(1, 2).produce((draft) {
        draft.value1 = 2;
      }).value1,
      2,
    );

    final draft = PositionalInts(1, 2).draft()..value1 = 10;
    expect(draft.save().value1, 10);
  });
}
