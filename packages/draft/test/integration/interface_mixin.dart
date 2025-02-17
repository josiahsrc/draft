import 'package:draft_annotation/draft_annotation.dart';

part 'interface_mixin.draft.dart';

mixin SomeMixin {
  String someMixinMethod() {
    return 'someMixinMethod';
  }
}

@draft
class Interface with SomeMixin {
  final int value;

  Interface({
    required this.value,
  });
}
