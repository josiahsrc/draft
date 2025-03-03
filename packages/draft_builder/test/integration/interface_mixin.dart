import 'package:draft/draft.dart';

part 'interface_mixin.draft.dart';

mixin SomeMixin {
  String someMixinMethod() {
    return 'someMixinMethod';
  }

  @override
  bool operator ==(Object other) {
    return false;
  }
}

@draft
class Interface with SomeMixin {
  final int value;

  Interface({
    required this.value,
  });
}
