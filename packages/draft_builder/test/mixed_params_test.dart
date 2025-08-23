import 'package:test/test.dart';

import 'common.dart';
import 'integration/mixed_params.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'mixed_params.dart';

void main() {
  MixedParams(1, InnerParams(1, value2: 2), 
    value2: 2, innerB: InnerParams(3, value2: 4),
  );
  MixedParams(1, InnerParams(1, value2: 2), 
    value2: 2, innerB: InnerParams(3, value2: 4),
  ).draft().save();
  MixedParams(1, InnerParams(1, value2: 2), 
    value2: 2, innerB: InnerParams(3, value2: 4),
  ).produce((draft) {
    draft.value1 = 2;
    draft.innerA.value1 = 3;
    draft.value2 = 4;
  });
}
'''),
      completes,
    );
  });

  test('works correctly', () async {
    expect(
      MixedParams(
        1,
        InnerParams(1, value2: 2),
        value2: 2,
        innerB: InnerParams(3, value2: 4),
      ).draft().value1,
      1,
    );
    expect(
      MixedParams(
        1,
        InnerParams(1, value2: 2),
        value2: 2,
        innerB: InnerParams(3, value2: 4),
      ).draft().value2,
      2,
    );
    expect(
      MixedParams(
        1,
        InnerParams(1, value2: 2),
        value2: 2,
        innerB: InnerParams(3, value2: 4),
      ).draft().innerB.value1,
      3,
    );

    final draft =
        MixedParams(
            1,
            InnerParams(1, value2: 2),
            value2: 2,
            innerB: InnerParams(3, value2: 4),
          ).draft()
          ..value1 = 10
          ..innerB = InnerParams(5, value2: 6);
    expect(draft.save().value1, 10);
    expect(draft.save().innerB.value1, 5);
    expect(draft.save().innerB.value2, 6);
  });
}
