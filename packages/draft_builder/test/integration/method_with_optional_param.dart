import 'package:draft/draft.dart';

part 'method_with_optional_param.draft.dart';

@draft
class ObjectWithOptionalParamMethod {
  ObjectWithOptionalParamMethod({required this.value1, required this.value2});

  final int value1;
  final int value2;

  List<int> toList([bool sorted = true]) {
    final list = [value1, value2];
    if (sorted) list.sort();
    return list;
  }
}
