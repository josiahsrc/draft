import 'package:test/test.dart';

import 'common.dart';
import 'integration/positional_optional.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'positional_optional.dart';

void main() {
  PositionalOptionalInts(1);
  PositionalOptionalInts(1, 2);
  PositionalOptionalInts(1).draft().save();
  PositionalOptionalIntsDraft(1).save();
  PositionalOptionalInts(1).produce((draft) {
    draft.value1 = 2;
    draft.value2 = 3;
  });
}
'''),
      completes,
    );
  });

  test('works correctly', () async {
    expect(PositionalOptionalInts(1).draft().value1, 1);
    expect(PositionalOptionalInts(1).draft().value2, 2);
    expect(PositionalOptionalIntsDraft(1).value2, 2);
    expect(PositionalOptionalInts(1, 3).draft().value2, 3);
    expect(
      PositionalOptionalInts(1).produce((draft) {
        draft.value2 = 2;
      }).value2,
      2,
    );

    final draft =
        PositionalOptionalInts(1).draft()
          ..value1 = 10
          ..value2 = 20;
    expect(draft.save().value1, 10);
    expect(draft.save().value2, 20);
  });
}
