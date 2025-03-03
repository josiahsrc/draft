import 'package:draft/draft.dart';

part 'collection.draft.dart';

@draft
class CollectionObject {
  final List<int> list;
  final Set<int> set;
  final Map<int, int> map;

  CollectionObject({required this.list, required this.set, required this.map});
}
