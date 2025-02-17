# Draft

Immer, but for dart. Convert between immutable and mutable objects.

:warning: This package is in its early stages and the API will change.

## Usage

Draft is inspired by immer.

```dart
import 'package:draft_annotation/draft_annotation.dart';

part 'example.draft.dart';

@draft
class Foo {
  final int value;

  const Foo({
    required this.value,
  });
}

void main() {
  final foo1 = Foo(value: 1);

  // Use the produce method
  final foo2 = foo1.produce((draft) {
    draft.value += 1;
  });
  assert(foo2.value == 2);

  // Or create drafts inline
  final fooDraft = foo.draft();
  fooDraft.value = 10;
  final foo3 = fooDraft.save();
  assert(foo3.value == 10);
}
```

See the [examples](https://github.com/josiahsrc/draft) directory for more info.

## Set up

First install draft and build runner, if you haven't already.

```sh
dart pub add dev:build_runner dev:draft draft_annotation
```

Next define your drafts.

```dart
// example.dart

import 'package:draft_annotation/draft_annotation.dart';

part 'example.draft.dart';

@draft
class Foo {
  final int value;

  const Foo({
    required this.value,
  });
}
```

Then run the build runner.

```sh
dart run build_runner build --delete-conflicting-outputs
```
