import 'package:draft/draft.dart';

part 'extension.draft.dart';

@draft
extension on BasicWithExtension {}

class BasicWithExtension {
  final int value;

  BasicWithExtension({required this.value});
}
