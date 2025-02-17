import 'package:draft_annotation/draft_annotation.dart';

part 'recursive.draft.dart';

@draft
class Recursive {
  final Recursive? item;

  Recursive({
    required this.item,
  });
}
