import 'package:draft/draft.dart';

part 'subtyping.draft.dart';

sealed class Parent extends Base with Mixin implements Interface {
  @override
  bool get flagA => true;

  @override
  void methodA() {}
}

@draft
class Child extends Parent {
  Child({required this.value});

  final int value;

  @override
  bool get flagB => false;

  @override
  void methodB() {}
}

abstract class Base {
  bool get flagA;
  void methodA();
}

abstract interface class Interface {
  bool get flagA;
  void methodB();
}

abstract mixin class Mixin {
  bool get flagB;
  void methodA();
}
