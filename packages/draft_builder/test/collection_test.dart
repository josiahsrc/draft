import 'package:test/test.dart';

import 'common.dart';
import 'integration/collection.dart';

void main() {
  test('compiles', () async {
    await expectLater(compile(r'''
import 'collection.dart';

void main() {
  CollectionObject(
    list: [1, 2, 3],
    set: {1, 2, 3},
    map: {1: 1, 2: 2, 3: 3},
  ).draft().save();
  CollectionObject(
    list: [1, 2, 3],
    set: {1, 2, 3},
    map: {1: 1, 2: 2, 3: 3},
  ).produce((draft) {
    draft.list.add(4);
    draft.set.add(4);
    draft.map[4] = 4;
  });
}
'''), completes);
  });

  test('works correctly', () async {
    final objA = CollectionObject(
      list: [1, 2, 3],
      set: {1, 2, 3},
      map: {1: 1, 2: 2, 3: 3},
    );

    final objB = objA.draft().save();
    expect(objB, isNot(equals(objA)));

    // list reference is not the same, but values are
    expect(identical(objA.list, objB.list), isFalse);
    expect(objB.list, [1, 2, 3]);
    expect(objA.list, [1, 2, 3]);

    // set reference is not the same, but values are
    expect(identical(objA.set, objB.set), isFalse);
    expect(objB.set, {1, 2, 3});
    expect(objA.set, {1, 2, 3});

    // map reference is not the same, but values are
    expect(identical(objA.map, objB.map), isFalse);
    expect(objB.map, {1: 1, 2: 2, 3: 3});
    expect(objA.map, {1: 1, 2: 2, 3: 3});
  });
}
