import 'package:draft/draft.dart';

part 'recursive.draft.dart';

@draft
class Recursive {
  final Recursive? item;

  Recursive({required this.item});
}
