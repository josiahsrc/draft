// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example.dart';

// **************************************************************************
// DraftGenerator
// **************************************************************************

class CoolInnerDraft implements CoolInner {
  int field;
  InnerInnerInnerDraft _inner;
  InnerInnerInnerDraft get inner => _inner;
  set inner(InnerInnerInner value) => _inner = value.draft();

  CoolInnerDraft({required this.field, required InnerInnerInnerDraft inner})
      : _inner = inner;

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

class InnerInnerInnerDraft implements InnerInnerInner {
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

class DataFieldsDraft implements DataFields {
  Map<String, String> map;
  List<String> list;
  Set<String> set;
  String? nullableString;

  DataFieldsDraft(
      {required this.map,
      required this.list,
      required this.set,
      required this.nullableString});

  DataFields save() => DataFields(
      map: map, list: list, set: set, nullableString: nullableString);
}

extension DataFieldsDraftExtension on DataFields {
  DataFieldsDraft draft() => DataFieldsDraft(
      map: this.map,
      list: this.list,
      set: this.set,
      nullableString: this.nullableString);

  DataFields produce(void Function(DataFieldsDraft draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}

class FooDraft implements Foo {
  String fieldA;
  String fieldB;
  BoringInner boringInner;
  CoolInnerDraft _coolInner;
  CoolInnerDraft get coolInner => _coolInner;
  set coolInner(CoolInner value) => _coolInner = value.draft();
  DataFieldsDraft _dataFields;
  DataFieldsDraft get dataFields => _dataFields;
  set dataFields(DataFields value) => _dataFields = value.draft();

  FooDraft(
      {required this.fieldA,
      required this.fieldB,
      required this.boringInner,
      required CoolInnerDraft coolInner,
      required DataFieldsDraft dataFields})
      : _coolInner = coolInner,
        _dataFields = dataFields;

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
