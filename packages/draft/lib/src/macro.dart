// TODO: Put public facing types in this file.

import 'dart:async';

import 'package:macros/macros.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

macro class Draft implements ClassDeclarationsMacro, ClassTypesMacro {
  const Draft();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final fields = await builder.fieldsOf(clazz);
    // final fieldsString = fields.map((f) => f.identifier.name).join(', ');

    // builder.declareInLibrary(DeclarationCode.fromParts([
    //   'class ${clazz.identifier.name}Draft {',
    //   for (final field in fields)
    //     '${field.type} ${field.identifier};',
    //   '}',
    // ]));

  //   SomeObject produce(void Function(SomeObjectDraft draft) fn) {
  //   final draft = this.draft();
  //   fn(draft);
  //   return draft.save();
  // }

    final name = '${clazz.identifier.name}Draft';
    builder.declareInType(DeclarationCode.fromParts([
        // 'void hello3()',
        // '{',
        // '  print("Hello, World!");',
        // '}',
        '$name draft() {',
        '  return $name(',
        for (final field in fields)
          '${field.identifier.name}: ${field.identifier.name},',
        ');',
        '}',
        '${clazz.identifier.name} produce(void Function($name draft) fn) {',
        '  final draft = this.draft();',
        '  fn(draft);',
        '  return draft.save();',
        '}',
      ]),);
  }

  @override
  FutureOr<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder,) async {
    // final fields = await clazz.
    final fields = ['fieldA', 'fieldB'];

    final name = '${clazz.identifier.name}Draft';
    builder.declareType(name, DeclarationCode.fromParts([
      'class $name {',
      for (final field in fields)
        'String ${field};',
      '$name({'
      'required this.fieldA,'
      'required this.fieldB,'
      '});',
      '${clazz.identifier.name} save() {',
      '  return ${clazz.identifier.name}(',
      for (final field in fields)
        '${field}: ${field},',
      ');',
      '}',
      '}',
    ]));
  }
}