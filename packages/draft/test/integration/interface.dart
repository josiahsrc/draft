import 'package:draft_annotation/draft_annotation.dart';

part 'interface.draft.dart';

@draft
class Interface {
  final int value;

  Interface({
    required this.value,
  });

  void someMethod() {
    print('someMethod');
  }

  int doubleValue() {
    return value * 2;
  }
}
