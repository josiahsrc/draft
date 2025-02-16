import 'package:draft_annotation/draft_annotation.dart';

part 'example.draft.dart';

@draft
class Foo {
  final String fieldA;
  final String fieldB;

  const Foo({
    required this.fieldA,
    required this.fieldB,
  });
}

void main() {
  final foo = Foo(fieldA: 'a', fieldB: 'b');

  final foo2 = foo.produce((draft) {
    draft.fieldB = 'c';
  });

  print(foo2.fieldB); // c

  final foo5 = foo.draft()
    ..fieldB = 'd'
    ..fieldA = 'e' * 5;

  print(foo5.save());
}
