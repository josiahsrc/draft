import 'package:test/test.dart';

import 'common.dart';
import 'integration/subtyping.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'subtyping.dart';

void main() {
  Child(value: 1);
  Child(value: 1).draft().save();
  Child(value: 1).draft().methodA();
  Child(value: 1).draft().methodB();
  bool a = Child(value: 1).draft().flagA;
  bool b = Child(value: 1).draft().flagB;
  Child(value: 1).produce((draft) {
    draft.value = 2;
    draft.methodA();
    draft.methodB();
    bool a1 = draft.flagA;
    bool b1 = draft.flagB;
  });
  Child(value: 1).methodA();
  Child(value: 1).methodB();
  bool a2 = Child(value: 1).flagA;
  bool b2 = Child(value: 1).flagB;
}
'''),
      completes,
    );
  });

  test('works correctly', () async {
    final instance = Child(value: 1);
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
    expect(saved.flagA, isTrue);
    expect(saved.draft().flagA, isTrue);
    expect(saved.flagB, isFalse);
    expect(saved.draft().flagB, isFalse);
  });
}
