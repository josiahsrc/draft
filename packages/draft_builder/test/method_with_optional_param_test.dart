import 'package:test/test.dart';

import 'common.dart';
import 'integration/method_with_param.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'method_with_optional_param.dart';

void main() {
  ObjectWithOptionalParamMethod(
    value1: 1,
    value2: 2,
  ).draft().save();
  ObjectWithOptionalParamMethod(
    value1: 1,
    value2: 2,
  ).produce((draft) {
    draft.value1 = 0;
    draft.value2 = 0;
  });
}
'''),
      completes,
    );
  });

  test('works correctly', () async {
    final obj = ObjectWithParamMethod(value1: 1, value2: 2);

    final obj2 = obj.draft().save();
    expect(obj2.value1, 1);
    expect(obj2.value2, 2);

    final obj3Draft = obj.draft();
    obj3Draft.value1 = 3;
    obj3Draft.value2 = 4;
    final obj3 = obj3Draft.save();
    expect(obj3.value1, 3);
    expect(obj3.value2, 4);

    final obj4 = obj.produce((draft) {
      draft.value1 = 5;
      draft.value2 = 6;
    });
    expect(obj4.value1, 5);
    expect(obj4.value2, 6);
  });
}
