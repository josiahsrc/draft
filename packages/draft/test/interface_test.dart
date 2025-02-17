import 'package:test/test.dart';

import 'common.dart';
import 'integration/interface.dart';

void main() {
  test('compiles', () async {
    await expectLater(compile(r'''
import 'interface.dart';

void main() {
  Interface(value: 1);
  Interface(value: 1).draft().save();
  Interface(value: 1).draft().someMethod();
  int a = Interface(value: 1).draft().doubleValue();
  int b = Interface(value: 1).draft().tripleValue;
  Interface(value: 1).produce((draft) {
    draft.value = 2;
    draft.someMethod();
    int a1 = draft.doubleValue();
    int b1 = draft.tripleValue;
  });
  Interface(value: 1).someMethod();
  int a2 = Interface(value: 1).doubleValue();
  int b2 = Interface(value: 1).tripleValue;
}
'''), completes);
  });

  test('works correctly', () async {
    final instance = Interface(value: 1);
    final draft = instance.draft();
    expect(draft.value, 1);
    draft.value = 2;
    expect(draft.value, 2);
    expect(instance.value, 1);
    final saved = draft.save();
    expect(saved.value, 2);
    expect(instance.value, 1);
    expect(saved, isNot(same(instance)));
    expect(saved, isNot(same(draft)));
    expect(saved.doubleValue(), 4);
    expect(saved.draft().doubleValue(), 4);
  });
}
