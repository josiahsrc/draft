import 'package:test/test.dart';

import 'common.dart';
import 'integration/nested.dart';

void main() {
  test('compiles', () async {
    await expectLater(compile(r'''
import 'nested.dart';

void main() {
  NestedRoot(
    draftable: NestedDraftable(value: 1),
    nonDraftable: NestedNonDraftable(value: 1),
    nullableDraftable: null,
    nullableNonDraftable: null,
  );
  NestedRoot(
    draftable: NestedDraftable(value: 1),
    nonDraftable: NestedNonDraftable(value: 1),
    nullableDraftable: null,
    nullableNonDraftable: null,
  ).draft()..draftable.value = 2;
  NestedRoot(
    draftable: NestedDraftable(value: 1),
    nonDraftable: NestedNonDraftable(value: 1),
    nullableDraftable: null,
    nullableNonDraftable: null,
  ).draft()
    ..draftable = NestedDraftable(value: 2)
    ..draftable = NestedDraftableDraft(value: 3)
    ..nonDraftable = NestedNonDraftable(value: 2);
}
'''), completes);
  });

  test('fail if modify non-draftable', () async {
    await expectLater(compile(r'''
import 'nested.dart';

void main() {
  NestedRoot(
    draftable: NestedDraftable(value: 1),
    nonDraftable: NestedNonDraftable(value: 1),
    nullableDraftable: null,
    nullableNonDraftable: null,
  ).draft().nonDraftable.value = 2;
}
'''), throwsCompileError);
  });

  test('works correctly', () async {
    final root = NestedRoot(
      draftable: NestedDraftable(value: 1),
      nonDraftable: NestedNonDraftable(value: 1),
      nullableDraftable: null,
      nullableNonDraftable: null,
    );

    var draft = root.draft();
    expect(draft.draftable.value, 1);
    expect(draft.draftable, isA<NestedDraftableDraft>());
    expect(draft.nonDraftable.value, 1);
    expect(draft.nonDraftable, isA<NestedNonDraftable>());
    expect(draft.nullableDraftable, isNull);
    expect(draft.nullableNonDraftable, isNull);

    draft.draftable.value = 2;
    draft.nonDraftable = NestedNonDraftable(value: 2);
    draft.nullableDraftable = NestedDraftable(value: 2);
    draft.nullableDraftable?.value = 3;
    draft.nullableNonDraftable = NestedNonDraftable(value: 2);

    final root2 = draft.save();
    expect(root2.draftable.value, 2);
    expect(root2.nonDraftable.value, 2);
    expect(root2.nullableDraftable, isNotNull);
    expect(root2.nullableNonDraftable, isNotNull);
    expect(root2.nullableDraftable!.value, 3);
    expect(root2.nullableNonDraftable!.value, 2);
    expect(identical(root, root2), isFalse);
    expect(identical(root.draftable, root2.draftable), isFalse);
    expect(identical(root.nonDraftable, root2.nonDraftable), isFalse);
    expect(identical(root.nullableDraftable, root2.nullableDraftable), isFalse);
    expect(
      identical(root.nullableNonDraftable, root2.nullableNonDraftable),
      isFalse,
    );

    draft = root2.draft();
    draft.nullableDraftable = null;
    draft.nullableNonDraftable = null;

    final root3 = draft.save();
    expect(root3.draftable.value, 2);
    expect(root3.nonDraftable.value, 2);
    expect(root3.nullableDraftable, isNull);
    expect(root3.nullableNonDraftable, isNull);
    expect(identical(root2, root3), isFalse);
    expect(identical(root2.draftable, root3.draftable), isFalse);
    expect(identical(root2.nonDraftable, root3.nonDraftable), isTrue);
  });
}
