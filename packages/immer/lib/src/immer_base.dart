// TODO: Put public facing types in this file.

import 'package:macros/macros.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

macro class Hello implements ClassDeclarationsMacro {
  const Hello();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    // final fields = await builder.fieldsOf(clazz);
    // final fieldsString = fields.map((f) => f.identifier.name).join(', ');

    builder.declareInType(
      DeclarationCode.fromParts([
        'void hello2()',
        '{',
        '  print("Hello, World!");',
        '}',
      ]),
    );
  }
}