<p align="center">
  <img src="https://raw.githubusercontent.com/josiahsrc/draft/main/assets/header.png" />
</p>

Draft is immer, but for dart.

Convert any object into a mutable draft, modify it, then convert it back to the immutable version. All while using a comfy API :)

```dart
import 'package:draft/draft.dart';

part 'example.draft.dart';

@draft
class Foo {
  final int value;
  const Foo(this.value);
}

// Foo is immutable, but we can edit it with Draft
Foo foo = Foo(1).produce((draft) {
  draft.value += 1;
});

// prints 2
print(foo.value);
```

See the [examples](https://github.com/josiahsrc/draft) directory for more info.

- [Pub package](https://pub.dev/packages/draft)
- [Source code](https://github.com/josiahsrc/draft/blob/main/packages/draft)

## Set up

First, install it

```sh
dart pub add dev:build_runner dev:draft_builder draft
```

Next, define your drafts

```dart
import 'package:draft/draft.dart';

part 'example.draft.dart';

@draft
class Foo {
  final int value;

  const Foo({
    required this.value,
  });
}
```

Then run the build runner

```sh
dart run build_runner build --delete-conflicting-outputs
```

Now you can use your drafts!

```dart
Foo(value: 1).produce((draft) {
  draft.value += 1;
});
```

## Use cases

Draft supports a variety of use cases and does its best to use native language features to make it easier to use.

### The `produce` method

The produce method exposes a callback that lets you modify a mutable version of the object and returns a new immutable instance.

```dart
final Foo foo = Foo(1).produce((draft) {
  draft.value += 1;
});
```

### The `draft` method

If you prefer, you can create a draft from your immutable object and modify it direct. When you're done editing it, call `save()` to get a new immutable instance.

```dart
// The original immutable object
final original = Foo(1, 2);

// Create and modify a draft
final draft = original.draft()
  ..value1 += 1
  ..value2 += 5;

// Convert it back into an immutable object
Foo foo = draft.save();
```

### Nested drafts

You can nest draftable classes inside of other draftable classes. Draft is smart and lets you modify the nested drafts.

```dart
@draft
class A {
  final B b;
  A(this.b);
}

@draft
class B {
  final int value;
  B(this.value);
}

final a = A(B(1)).produce((draft) {
  draft.b.value += 1;
});
```

### Collections

You can modify collections inline. Draft will create copies of the collection, without affecting the original.

```dart
@draft
class C {
  final List<int> values;
  C(this.values);
}

final c = C([1, 2, 3]).produce((draft) {
  draft.values[0] += 1;
});
```

### Equality

Draft is unopinionated and does not provide any sort of equality checking out of the box. If you want equality checking, consider using [equatable](https://pub.dev/packages/equatable)

## Contributing

If you like the package and want to contribute, feel free to [open and issue or create a PR](https://github.com/josiahsrc/draft/tree/main). I'm always open to suggestions and improvements.

---

keywords: flutter, dart, immutable, mutable, immer, draft
