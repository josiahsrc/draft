import 'package:draft/draft.dart';

part 'nested_collection.draft.dart';

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
class NestedCollectionRoot {
  final List<NestedDraftable> draftable;
  final List<NestedNonDraftable> nonDraftable;

  NestedCollectionRoot({
    required this.draftable,
    required this.nonDraftable,
  });
}
