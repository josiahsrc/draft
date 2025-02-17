// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example.dart';

// **************************************************************************
// DraftGenerator
// **************************************************************************

class CoolInnerDraft {
  int field;
  InnerInnerInnerDraft inner;

  CoolInnerDraft({required this.field, required this.inner});

  CoolInner save() => CoolInner(field: field, inner: inner.save());
}

extension CoolInnerDraftExtension on CoolInner {
  CoolInnerDraft draft() =>
      CoolInnerDraft(field: this.field, inner: this.inner.draft());

  CoolInner produce(void Function(CoolInnerDraft draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}

class InnerInnerInnerDraft {
  int field;

  InnerInnerInnerDraft({required this.field});

  InnerInnerInner save() => InnerInnerInner(field: field);
}

extension InnerInnerInnerDraftExtension on InnerInnerInner {
  InnerInnerInnerDraft draft() => InnerInnerInnerDraft(field: this.field);

  InnerInnerInner produce(void Function(InnerInnerInnerDraft draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}

class DataFieldsDraft {
  Map<String, String> map;
  List<String> list;
  Set<String> set;
  Set<String>? nullableSet;
  Map<String, String>? nullableMap;
  List<String>? nullableList;
  String? nullableString;

  DataFieldsDraft(
      {required this.map,
      required this.list,
      required this.set,
      required this.nullableSet,
      required this.nullableMap,
      required this.nullableList,
      required this.nullableString});

  DataFields save() => DataFields(
      map: Map.from(map),
      list: List.from(list),
      set: Set.from(set),
      nullableSet: nullableSet == null ? null : Set.from(nullableSet!),
      nullableMap: nullableMap == null ? null : Map.from(nullableMap!),
      nullableList: nullableList == null ? null : List.from(nullableList!),
      nullableString: nullableString);
}

extension DataFieldsDraftExtension on DataFields {
  DataFieldsDraft draft() => DataFieldsDraft(
      map: Map.from(this.map),
      list: List.from(this.list),
      set: Set.from(this.set),
      nullableSet: nullableSet == null ? null : Set.from(this.nullableSet!),
      nullableMap: nullableMap == null ? null : Map.from(this.nullableMap!),
      nullableList: nullableList == null ? null : List.from(this.nullableList!),
      nullableString: this.nullableString);

  DataFields produce(void Function(DataFieldsDraft draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}

class FooDraft {
  String fieldA;
  String fieldB;
  BoringInner boringInner;
  CoolInnerDraft coolInner;
  DataFieldsDraft dataFields;

  FooDraft(
      {required this.fieldA,
      required this.fieldB,
      required this.boringInner,
      required this.coolInner,
      required this.dataFields});

  Foo save() => Foo(
      fieldA: fieldA,
      fieldB: fieldB,
      boringInner: boringInner,
      coolInner: coolInner.save(),
      dataFields: dataFields.save());
}

extension FooDraftExtension on Foo {
  FooDraft draft() => FooDraft(
      fieldA: this.fieldA,
      fieldB: this.fieldB,
      boringInner: this.boringInner,
      coolInner: this.coolInner.draft(),
      dataFields: this.dataFields.draft());

  Foo produce(void Function(FooDraft draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}
