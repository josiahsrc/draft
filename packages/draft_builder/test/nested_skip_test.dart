import 'package:test/test.dart';

import 'common.dart';
import 'integration/nested_skip.dart';

void main() {
  test('compiles', () async {
    await expectLater(compile(r'''
import 'nested_skip.dart';

void main() {
  A(
    b: B(c: C(value: 1)),
  );
  A(
    b: B(c: C(value: 1)),
  ).draft()
    ..b = B(c: C(value: 2));
}
'''), completes);
  });

  test('fail if modify nested draftable inside skipped type', () async {
    await expectLater(compile(r'''
import 'nested_skip.dart';

void main() {
  // b is a non-draftable type, so attempting to modify its internals (like c.value) should fail.
  A(
    b: B(c: C(value: 1)),
  ).draft().b.c.value = 2;
}
'''), throwsCompileError);
  });

  test('works correctly', () {
    final a = A(
      b: B(c: C(value: 1)),
    );

    // Create a draft from A.
    final draft = a.draft();

    // Since B is skipped, the field 'b' in the draft is the same instance as in a.
    expect(draft.b.c.value, 1);
    expect(identical(draft.b, a.b), isTrue);

    // To update the value inside 'c', we must replace the entire b.
    // Create a new instance of B (with a new C) and assign it.
    final newB = B(c: C(value: 2));
    draft.b = newB;

    final a2 = draft.save();
    expect(a2.b.c.value, 2);
    // The new B instance is different from the original one.
    expect(identical(a.b, a2.b), isFalse);
  });
}
