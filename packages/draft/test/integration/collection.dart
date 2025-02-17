import 'package:draft_annotation/draft_annotation.dart';

part 'collection.draft.dart';

@draft
class CollectionObject {
  final List<int> list;
  final Set<int> set;
  final Map<int, int> map;

  CollectionObject({
    required this.list,
    required this.set,
    required this.map,
  });
}
