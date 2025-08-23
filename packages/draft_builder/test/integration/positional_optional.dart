import 'package:draft/draft.dart';

part 'positional_optional.draft.dart';

@draft
class PositionalOptionalInts {
  final int value1;
  final int value2;

  PositionalOptionalInts(this.value1, [this.value2 = 2]);
}
