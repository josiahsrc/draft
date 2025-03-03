import 'package:draft/draft.dart';

part 'interface.draft.dart';

@draft
class Interface {
  final int value;

  Interface({required this.value});

  void someMethod() {
    print('someMethod');
  }

  int doubleValue() {
    return value * 2;
  }

  int get tripleValue => value * 3;
}
