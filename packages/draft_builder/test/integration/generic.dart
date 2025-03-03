import 'package:draft/draft.dart';

part 'generic.draft.dart';

@draft
class BasicGeneric<T> {
  final T value;

  BasicGeneric({required this.value});
}

class SomeValue {
  final int value;

  SomeValue(this.value);
}

@draft
class ConstrainedGeneric<T extends SomeValue> {
  final T value;

  ConstrainedGeneric({required this.value});
}

@draft
class MultipleGenerics<T, U> {
  final T value1;
  final U value2;

  MultipleGenerics({required this.value1, required this.value2});
}
