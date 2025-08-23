// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark, must_be_immutable

part of 'example.dart';

// **************************************************************************
// DraftGenerator
// **************************************************************************

class CoolInnerDraft implements CoolInner {
  // Mutable fields
  int field;
  InnerInnerInnerDraft _inner;

  // Getters and setters for nested draftable fields

  InnerInnerInnerDraft get inner => _inner;
  set inner(InnerInnerInner value) => _inner = value.draft();

  CoolInnerDraft({required this.field, required InnerInnerInner inner})
      : _inner = inner.draft();

  CoolInner save() => CoolInner(field: field, inner: inner);
}

extension CoolInnerDraftExtension on CoolInner {
  CoolInnerDraft draft() =>
      CoolInnerDraft(field: this.field, inner: this.inner);
  CoolInner produce(void Function(CoolInnerDraft draft) producer) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}

class InnerInnerInnerDraft implements InnerInnerInner {
  // Mutable fields
  int field;

  // Getters and setters for nested draftable fields

  InnerInnerInnerDraft({required this.field});

  InnerInnerInner save() => InnerInnerInner(field: field);
}

extension InnerInnerInnerDraftExtension on InnerInnerInner {
  InnerInnerInnerDraft draft() => InnerInnerInnerDraft(field: this.field);
  InnerInnerInner produce(void Function(InnerInnerInnerDraft draft) producer) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}

class DataFieldsDraft implements DataFields {
  // Mutable fields
  Map<String, String> _map;
  List<String> _list;
  Set<String> _set;
  Set<String>? _nullableSet;
  Map<String, String>? _nullableMap;
  List<String>? _nullableList;
  String? nullableString;

  // Getters and setters for nested draftable fields
  Map<String, String> get map => _map;
  set map(Map<String, String> value) =>
      _map = value.map((k, v) => MapEntry(k, v));

  List<String> get list => _list;
  set list(List<String> value) => _list = value.map((e) => e).toList();

  Set<String> get set => _set;
  set set(Set<String> value) => _set = value.map((e) => e).toSet();

  Set<String>? get nullableSet => _nullableSet;
  set nullableSet(Set<String>? value) =>
      _nullableSet = value?.map((e) => e).toSet();

  Map<String, String>? get nullableMap => _nullableMap;
  set nullableMap(Map<String, String>? value) =>
      _nullableMap = value?.map((k, v) => MapEntry(k, v));

  List<String>? get nullableList => _nullableList;
  set nullableList(List<String>? value) =>
      _nullableList = value?.map((e) => e).toList();

  DataFieldsDraft(
      {required Map<String, String> map,
      required List<String> list,
      required Set<String> set,
      required this.nullableString,
      required Set<String>? nullableSet,
      required Map<String, String>? nullableMap,
      required List<String>? nullableList})
      : _map = map.map((k, v) => MapEntry(k, v)),
        _list = list.map((e) => e).toList(),
        _set = set.map((e) => e).toSet(),
        _nullableSet = nullableSet?.map((e) => e).toSet(),
        _nullableMap = nullableMap?.map((k, v) => MapEntry(k, v)),
        _nullableList = nullableList?.map((e) => e).toList();

  DataFields save() => DataFields(
      map: map,
      list: list,
      set: set,
      nullableString: nullableString,
      nullableSet: nullableSet,
      nullableMap: nullableMap,
      nullableList: nullableList);
}

extension DataFieldsDraftExtension on DataFields {
  DataFieldsDraft draft() => DataFieldsDraft(
      map: this.map,
      list: this.list,
      set: this.set,
      nullableString: this.nullableString,
      nullableSet: this.nullableSet,
      nullableMap: this.nullableMap,
      nullableList: this.nullableList);
  DataFields produce(void Function(DataFieldsDraft draft) producer) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}

class FooDraft implements Foo {
  // Mutable fields
  String fieldA;
  String fieldB;
  BoringInner boringInner;
  CoolInnerDraft _coolInner;
  DataFieldsDraft _dataFields;

  // Getters and setters for nested draftable fields

  CoolInnerDraft get coolInner => _coolInner;
  set coolInner(CoolInner value) => _coolInner = value.draft();

  DataFieldsDraft get dataFields => _dataFields;
  set dataFields(DataFields value) => _dataFields = value.draft();

  FooDraft(
      {required this.fieldA,
      required this.fieldB,
      required this.boringInner,
      required CoolInner coolInner,
      required DataFields dataFields})
      : _coolInner = coolInner.draft(),
        _dataFields = dataFields.draft();

  Foo save() => Foo(
      fieldA: fieldA,
      fieldB: fieldB,
      boringInner: boringInner,
      coolInner: coolInner,
      dataFields: dataFields);
}

extension FooDraftExtension on Foo {
  FooDraft draft() => FooDraft(
      fieldA: this.fieldA,
      fieldB: this.fieldB,
      boringInner: this.boringInner,
      coolInner: this.coolInner,
      dataFields: this.dataFields);
  Foo produce(void Function(FooDraft draft) producer) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}
