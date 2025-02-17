import 'package:draft_annotation/draft_annotation.dart';

part 'example.draft.dart';

@draft
class Draftable {
  final int value;
  final List<int> list;

  Draftable({
    required this.value,
    required this.list,
  });
}

class NotDraftable {
  final int value;

  NotDraftable({
    required this.value,
  });
}

@draft
class Data {
  final NotDraftable notDraftable;
  final Draftable draftable;

  Data({
    required this.notDraftable,
    required this.draftable,
  });

  int get doubleValue => draftable.list.length * 2;

  void cool() {
    print('cool');
  }
}
