import 'package:test/test.dart';

import 'common.dart';
import 'integration/basic.dart';
import 'integration/generic.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'generic.dart';

void main() {
  BasicGeneric<int>(value: 1);
  BasicGeneric<int>(value: 1).draft().save();
  BasicGeneric<int>(value: 1).produce((draft) {
    draft.value = 2;
  });
}
'''),
      completes,
    );
  });

  test('basic generic correctly', () async {
    expect(BasicGeneric<int>(value: 1).draft().value, 1);
    expect(BasicGeneric<int>(value: 1).draft().save().value, 1);
    expect(
      BasicGeneric<int>(value: 1).produce((draft) {
        draft.value = 2;
      }).value,
      2,
    );

    final draft = BasicInt(value: 1).draft()..value = 10;
    expect(draft.save().value, 10);
  });

  test('constrained generic correctly', () async {
    expect(
      ConstrainedGeneric<SomeValue>(value: SomeValue(1)).draft().value.value,
      1,
    );
    expect(
      ConstrainedGeneric<SomeValue>(
        value: SomeValue(1),
      ).draft().save().value.value,
      1,
    );
    expect(
      ConstrainedGeneric<SomeValue>(value: SomeValue(1))
          .produce((draft) {
            draft.value = SomeValue(2);
          })
          .value
          .value,
      2,
    );
    expect(
      ConstrainedGeneric<SomeValue>(
        value: SomeValue(1),
      ).draft().save().value.value,
      1,
    );
    expect(
      ConstrainedGeneric<SomeValue>(value: SomeValue(1))
          .produce((draft) {
            draft.value = SomeValue(2);
          })
          .value
          .value,
      2,
    );
    expect(
      ConstrainedGeneric<SomeValue>(
        value: SomeValue(1),
      ).draft().save().value.value,
      1,
    );
  });

  test('multiple generics correctly', () async {
    expect(
      MultipleGenerics<int, String>(value1: 1, value2: 'test').draft().value1,
      1,
    );
    expect(
      MultipleGenerics<int, String>(
        value1: 1,
        value2: 'test',
      ).draft().save().value1,
      1,
    );
    expect(
      MultipleGenerics<int, String>(value1: 1, value2: 'test').produce((draft) {
        draft.value1 = 2;
        draft.value2 = 'changed';
      }).value1,
      2,
    );
    expect(
      MultipleGenerics<int, String>(
        value1: 1,
        value2: 'test',
      ).draft().save().value2,
      'test',
    );
    expect(
      MultipleGenerics<int, String>(value1: 1, value2: 'test').produce((draft) {
        draft.value1 = 2;
        draft.value2 = 'changed';
      }).value2,
      'changed',
    );
  });
}
