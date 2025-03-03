import 'package:test/test.dart';

import 'common.dart';
import 'integration/nested_collection.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'nested_collection.dart';

void main() {
  NestedCollectionRoot(
    draftable: [NestedDraftable(value: 1)],
    nonDraftable: [NestedNonDraftable(value: 1)],
  );
  NestedCollectionRoot(
    draftable: [NestedDraftable(value: 1)],
    nonDraftable: [NestedNonDraftable(value: 1)],
  ).draft()
    ..draftable[0].value = 2;
  NestedCollectionRoot(
    draftable: [NestedDraftable(value: 1)],
    nonDraftable: [NestedNonDraftable(value: 1)],
  ).draft()
    ..draftable[0] = NestedDraftableDraft(value: 3)
    ..nonDraftable[0] = NestedNonDraftable(value: 2);
}
'''),
      completes,
    );
  });

  test('fail if modify non-draftable element', () async {
    await expectLater(
      compile(r'''
import 'nested_collection.dart';

void main() {
  NestedCollectionRoot(
    draftable: [NestedDraftable(value: 1)],
    nonDraftable: [NestedNonDraftable(value: 1)],
  ).draft().nonDraftable[0].value = 2;
}
'''),
      throwsCompileError,
    );
  });

  test('works correctly', () async {
    final root = NestedCollectionRoot(
      draftable: [NestedDraftable(value: 1)],
      nonDraftable: [NestedNonDraftable(value: 1)],
    );

    var draft = root.draft();

    // Check initial values and types.
    expect(draft.draftable[0].value, 1);
    expect(draft.draftable[0], isA<NestedDraftableDraft>());
    expect(draft.nonDraftable[0].value, 1);
    expect(draft.nonDraftable[0], isA<NestedNonDraftable>());

    // Modify values.
    draft.draftable[0].value = 2;
    draft.nonDraftable[0] = NestedNonDraftable(value: 2);

    final root2 = draft.save();

    // Verify that the new instance reflects the changes.
    expect(root2.draftable[0].value, 2);
    expect(root2.nonDraftable[0].value, 2);
    expect(identical(root, root2), isFalse);
    expect(identical(root.draftable, root2.draftable), isFalse);
    expect(identical(root.nonDraftable, root2.nonDraftable), isFalse);
    expect(identical(root.draftable[0], root2.draftable[0]), isFalse);
    expect(identical(root.nonDraftable[0], root2.nonDraftable[0]), isFalse);

    // Further modifications
    draft = root2.draft();
    draft.draftable[0] = NestedDraftable(value: 3).draft();
    draft.nonDraftable[0] = NestedNonDraftable(value: 3);

    final root3 = draft.save();
    expect(root3.draftable[0].value, 3);
    expect(root3.nonDraftable[0].value, 3);
    expect(identical(root2.draftable[0], root3.draftable[0]), isFalse);
    expect(identical(root2.nonDraftable[0], root3.nonDraftable[0]), isFalse);
  });
}
