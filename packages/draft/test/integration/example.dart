import 'package:draft_annotation/draft_annotation.dart';

part 'example.draft.dart';

@draft
class Inner {
  final int value;

  Inner({
    required this.value,
  });
}

@draft
class Data {
  final List<Map<String, Inner>> list;

  Data({
    required this.list,
  });

  int get doubleValue => list.length * 2;
}
