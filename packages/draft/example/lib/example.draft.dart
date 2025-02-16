// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example.dart';

// **************************************************************************
// DraftGenerator
// **************************************************************************

class FooDraft {
  String fieldA;
  String fieldB;

  FooDraft({required this.fieldA, required this.fieldB});

  Foo save() => Foo(fieldA: fieldA, fieldB: fieldB);
}

extension FooDraftExtension on Foo {
  FooDraft draft() => FooDraft(fieldA: this.fieldA, fieldB: this.fieldB);

  Foo produce(void Function(FooDraft draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}
