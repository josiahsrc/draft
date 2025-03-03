import 'package:draft/draft.dart';

part 'nested_skip.draft.dart';

@draft
class C {
  final int value;

  C({required this.value});
}

class B {
  final C c;

  B({required this.c});
}

@draft
class A {
  final B b;

  A({required this.b});
}
