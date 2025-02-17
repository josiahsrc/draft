import 'package:draft_annotation/draft_annotation.dart';

@draft
class Inner {
  final int value;

  Inner({
    required this.value,
  });
}

@Draft(constructor: 'other')
class Data {
  final int value;
  final Inner inner;
  final List<Map<String, Inner>> list;

  Data.other({
    required this.value,
    required this.inner,
    required this.list,
  });

  int get doubleValue => value * 2;
}

class InnerDraft implements Inner {
  int value;

  InnerDraft({required this.value});

  Inner save() => Inner(value: value);
}

class DataDraft implements Data {
  int value;

  InnerDraft _inner;
  InnerDraft get inner => _inner;
  set inner(Inner value) => _inner = value.draft();

  List<Map<String, InnerDraft>> _list;
  List<Map<String, InnerDraft>> get list => _list;
  set list(List<Map<String, Inner>> value) => _list =
      value.map((e) => e.map((k, v) => MapEntry(k, v.draft()))).toList();

  DataDraft(
      {required this.value,
      required Inner inner,
      required List<Map<String, Inner>> list})
      : _inner = inner.draft(),
        _list =
            list.map((e) => e.map((k, v) => MapEntry(k, v.draft()))).toList();

  Data save() => Data.other(
        value: value,
        inner: inner.save(),
        list: list.map((e) => e.map((k, v) => MapEntry(k, v.save()))).toList(),
      );

  int get doubleValue => save().doubleValue;
}

extension InnerDraftExtension on Inner {
  InnerDraft draft() => InnerDraft(value: this.value);
}

extension DataDraftExtension on Data {
  DataDraft draft() =>
      DataDraft(value: this.value, inner: this.inner, list: this.list);
}
