import 'package:test/test.dart';

import 'common.dart';
import 'integration/recursive.dart';

void main() {
  test('compiles', () async {
    await expectLater(compile(r'''
import 'recursive.dart';

void main() {
  // Create a recursive instance with a null inner item.
  Recursive(item: null);

  // Create a recursive instance with a non-null inner item.
  Recursive(item: Recursive(item: null)).draft()
    // Replace the inner recursive node.
    ..item = Recursive(item: null);

  // Create a recursive instance and modify the inner node via its draft.
  Recursive(item: Recursive(item: null)).draft()
    ..item?.item = Recursive(item: null);
}
'''), completes);
  });

  test('works correctly', () {
    // Build a recursive structure:
    // outer -> inner (with item: null)
    final original = Recursive(item: Recursive(item: null));

    // Create a draft of the outer instance.
    var draft = original.draft();

    // The draft of the inner instance should be non-null.
    expect(draft.item, isNotNull);
    expect(draft.item!.item, isNull);

    // Replace the inner recursive field with a new instance,
    // now inner has a non-null child.
    draft.item = Recursive(item: Recursive(item: null));

    final modified = draft.save();

    // The modified outer instance should reflect the change.
    expect(modified.item, isNotNull);
    expect(modified.item!.item, isNotNull);

    // Now modify the inner inner node.
    final draft2 = modified.draft();
    // Set the inner inner node to null.
    draft2.item!.item = null;

    final finalResult = draft2.save();

    // Verify the change: the inner inner node is now null.
    expect(finalResult.item!.item, isNull);
    // And the outer and inner nodes remain updated.
    expect(finalResult.item, isNotNull);
  });
}
