import 'package:draft_annotation/draft_annotation.dart';

part 'nested.draft.dart';

@draft
class NestedDraftable {
  final int value;

  NestedDraftable({
    required this.value,
  });
}

class NestedNonDraftable {
  final int value;

  NestedNonDraftable({
    required this.value,
  });
}

@draft
class NestedRoot {
  final NestedDraftable draftable;
  final NestedNonDraftable nonDraftable;
  final NestedDraftable? nullableDraftable;
  final NestedNonDraftable? nullableNonDraftable;

  NestedRoot({
    required this.draftable,
    required this.nonDraftable,
    required this.nullableDraftable,
    required this.nullableNonDraftable,
  });
}
