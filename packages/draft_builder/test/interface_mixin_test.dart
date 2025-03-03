import 'package:test/test.dart';

import 'common.dart';
import 'integration/interface_mixin.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'interface_mixin.dart';

void main() {
  // Creating an instance and using its mixin method.
  final instance = Interface(value: 1);
  instance.someMixinMethod();

  // Creating a draft and modifying the value.
  final draft = instance.draft();
  draft.value = 2;
  draft.someMixinMethod();
}
'''),
      completes,
    );
  });

  test('works correctly', () {
    // Create an instance of Interface.
    final instance = Interface(value: 1);

    // Check that the mixin method works.
    // Here we just call it to ensure it doesn't throw.
    instance.someMixinMethod();

    // Create a draft from the instance.
    final draft = instance.draft();
    expect(draft.value, 1);
    // Mixin method should also be available on the draft.
    draft.someMixinMethod();

    // Modify the draft's value.
    draft.value = 42;

    // Save the draft, creating a new instance.
    final updated = draft.save();

    // Verify that the new instance reflects the modification.
    expect(updated.value, 42);
    // Check that the mixin method is still available.
    updated.someMixinMethod();

    // Ensure that the updated instance is not identical to the original.
    expect(identical(instance, updated), isFalse);
  });
}
