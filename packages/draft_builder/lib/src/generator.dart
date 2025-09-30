import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:draft/draft.dart';
import 'package:source_gen/source_gen.dart';

/// Helper to decide if a type is “primitive.”
bool _isPrimitive(DartType type) {
  return type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreNum ||
      type.isDartCoreString;
}

/// Checks if the type is a List.
bool _isList(DartType type) => type.isDartCoreList;

/// Checks if the type is a Map.
bool _isMap(DartType type) => type.isDartCoreMap;

/// Checks if the type is a Set.
bool _isSet(DartType type) => type.isDartCoreSet;

/// Returns the draft type name for a given type.
/// For example, if the original is `Inner` then the draft type is `InnerDraft`.
String _draftTypeName(String? originalName) {
  if (originalName == null) return 'dynamic';
  if (originalName.endsWith('?')) {
    return '${originalName.substring(0, originalName.length - 1)}Draft?';
  }
  return '${originalName}Draft';
}

/// Returns whether the type is nullable.
bool _isNullable(DartType type) =>
    type.nullabilitySuffix != NullabilitySuffix.none;

/// Recursively converts a DartType into the drafted type name.
/// For collections it recurses into type arguments and preserves nullability.
/// For non-collection types, if the type is draftable then we append "Draft",
/// otherwise we leave it as is.
String _toDraftedTypeName(DartType type) {
  String base;
  if (_isPrimitive(type)) {
    base = type.getDisplayString();
  } else if (_isList(type)) {
    final listArg = (type as ParameterizedType).typeArguments.first;
    base = 'List<${_toDraftedTypeName(listArg)}>';
  } else if (_isMap(type)) {
    final paramType = type as ParameterizedType;
    final keyType = paramType.typeArguments[0].getDisplayString();
    final valueType = paramType.typeArguments[1];
    base = 'Map<$keyType, ${_toDraftedTypeName(valueType)}>';
  } else if (_isSet(type)) {
    final setType = type as ParameterizedType;
    final setTypeArg = setType.typeArguments.first;
    base = 'Set<${_toDraftedTypeName(setTypeArg)}>';
  } else {
    base =
        _isDraftable(type)
            ? _draftTypeName(type.getDisplayString())
            : type.getDisplayString();
  }
  return _isNullable(type) ? '$base?' : base;
}

/// Returns an expression that converts a value into its draft.
/// For primitives, returns the value as is.
/// For collections, it recursively maps the conversion using null-aware operators.
/// For non-collection objects, if the type is draftable, calls `.draft()`,
/// otherwise returns the value unchanged.
String _toDraftExpression(String? expr, DartType type) {
  if (expr == null) {
    return 'null';
  }
  if (_isPrimitive(type)) {
    return expr;
  }
  final nullable = _isNullable(type);
  if (_isList(type)) {
    final listArg = (type as ParameterizedType).typeArguments.first;
    final innerExpr = _toDraftExpression("e", listArg);
    return nullable
        ? '$expr?.map((e) => $innerExpr).toList()'
        : '$expr.map((e) => $innerExpr).toList()';
  } else if (_isMap(type)) {
    final paramType = type as ParameterizedType;
    final valueType = paramType.typeArguments[1];
    return nullable
        ? '$expr?.map((k, v) => MapEntry(k, ${_toDraftExpression("v", valueType)}))'
        : '$expr.map((k, v) => MapEntry(k, ${_toDraftExpression("v", valueType)}))';
  } else if (_isSet(type)) {
    final setType = type as ParameterizedType;
    final setTypeArg = setType.typeArguments.first;
    return nullable
        ? '$expr?.map((e) => ${_toDraftExpression("e", setTypeArg)}).toSet()'
        : '$expr.map((e) => ${_toDraftExpression("e", setTypeArg)}).toSet()';
  } else {
    return _isDraftable(type)
        ? (nullable ? '$expr?.draft()' : '$expr.draft()')
        : expr;
  }
}

/// Returns an expression that “saves” a draft field back to its original.
/// For primitives, returns as is.
/// For collections, it recursively maps the conversion using null-aware operators.
/// For non-collection objects, if the type is draftable, calls `.save()`,
/// otherwise returns the value unchanged.
String _toSaveExpression(String? expr, DartType type) {
  if (expr == null) {
    return 'null';
  }
  if (_isPrimitive(type)) {
    return expr;
  }
  final nullable = _isNullable(type);
  if (_isList(type)) {
    final listArg = (type as ParameterizedType).typeArguments.first;
    return nullable
        ? '$expr?.map((e) => ${_toSaveExpression("e", listArg)}).toList()'
        : '$expr.map((e) => ${_toSaveExpression("e", listArg)}).toList()';
  } else if (_isMap(type)) {
    final paramType = type as ParameterizedType;
    final valueType = paramType.typeArguments[1];
    return nullable
        ? '$expr?.map((k, v) => MapEntry(k, ${_toSaveExpression("v", valueType)}))'
        : '$expr.map((k, v) => MapEntry(k, ${_toSaveExpression("v", valueType)}))';
  } else if (_isSet(type)) {
    final setType = type as ParameterizedType;
    final setTypeArg = setType.typeArguments.first;
    return nullable
        ? '$expr?.map((e) => ${_toSaveExpression("e", setTypeArg)}).toSet()'
        : '$expr.map((e) => ${_toSaveExpression("e", setTypeArg)}).toSet()';
  } else {
    return _isDraftable(type)
        ? (nullable ? '$expr?.save()' : '$expr.save()')
        : expr;
  }
}

/// Determines whether a type is draftable by checking if its element has the @draft annotation.
bool _isDraftable(DartType type) {
  final el = type.element;
  if (el is ClassElement) {
    return const TypeChecker.typeNamed(
      Draft,
      inPackage: 'draft',
    ).hasAnnotationOfExact(el);
  }
  return false;
}

/// Abstract field processor that knows how to generate code for a single field.
abstract class FieldProcessor {
  FieldProcessor(this.field);
  final FieldElement field;

  /// Returns the field declaration in the draft class.
  String generateFieldDeclaration();

  /// Returns any getters and setters to be added.
  String generateGetterSetter();

  /// Returns a parameter declaration for the draft constructor.
  String generateConstructorParameter();

  /// Returns the initializer expression for the draft constructor.
  String generateConstructorInitializer();

  /// Returns the assignment expression used in the save() method.
  String generateSaveAssignment();
}

/// Processor for primitive fields.
class PrimitiveFieldProcessor extends FieldProcessor {
  PrimitiveFieldProcessor(super.field);

  @override
  String generateFieldDeclaration() {
    return '${field.type.getDisplayString()} ${field.name};';
  }

  @override
  String generateGetterSetter() => '';

  @override
  String generateConstructorParameter() {
    return 'required this.${field.name}';
  }

  @override
  String generateConstructorInitializer() => '';

  @override
  String generateSaveAssignment() => '${field.name}: ${field.name}';
}

/// Processor for fields that are draftable objects.
class DraftableFieldProcessor extends FieldProcessor {
  DraftableFieldProcessor(super.field);

  String get privateName => '_${field.name}';
  String get originalType => field.type.getDisplayString();
  String get draftType => _draftTypeName(originalType);

  @override
  String generateFieldDeclaration() {
    return '$draftType $privateName;';
  }

  @override
  String generateGetterSetter() {
    return '''
  $draftType get ${field.name} => $privateName;
  set ${field.name}($originalType value) => $privateName = ${_toDraftExpression("value", field.type)};
''';
  }

  @override
  String generateConstructorParameter() {
    return 'required $originalType ${field.name}';
  }

  @override
  String generateConstructorInitializer() {
    return '$privateName = ${_toDraftExpression(field.name, field.type)}';
  }

  @override
  String generateSaveAssignment() {
    return '${field.name}: ${_toSaveExpression(field.name, field.type)}';
  }
}

/// Processor for non-draftable (but non-primitive) fields.
class SimpleFieldProcessor extends FieldProcessor {
  SimpleFieldProcessor(super.field);

  @override
  String generateFieldDeclaration() {
    return '${field.type.getDisplayString()} ${field.name};';
  }

  @override
  String generateGetterSetter() => '';

  @override
  String generateConstructorParameter() {
    return 'required this.${field.name}';
  }

  @override
  String generateConstructorInitializer() => '';

  @override
  String generateSaveAssignment() => '${field.name}: ${field.name}';
}

/// Processor for collection fields (List, Map, or Set) where inner types may be draftable.
class CollectionFieldProcessor extends FieldProcessor {
  CollectionFieldProcessor(super.field);

  String get privateName => '_${field.name}';

  String _draftedCollectionType() {
    return _toDraftedTypeName(field.type);
  }

  @override
  String generateFieldDeclaration() {
    return '${_draftedCollectionType()} $privateName;';
  }

  @override
  String generateGetterSetter() {
    final originalType = field.type.getDisplayString();
    return '''
  ${_draftedCollectionType()} get ${field.name} => $privateName;
  set ${field.name}($originalType value) => $privateName = ${_toDraftExpression("value", field.type)};
''';
  }

  @override
  String generateConstructorParameter() {
    return 'required ${field.type.getDisplayString()} ${field.name}';
  }

  @override
  String generateConstructorInitializer() {
    return '$privateName = ${_toDraftExpression(field.name, field.type)}';
  }

  @override
  String generateSaveAssignment() {
    return '${field.name}: ${_toSaveExpression(field.name, field.type)}';
  }
}

/// Factory that selects the proper field processor.
FieldProcessor _processorFor(FieldElement field) {
  final type = field.type;
  if (_isPrimitive(type)) {
    return PrimitiveFieldProcessor(field);
  } else if (_isList(type) || _isMap(type) || _isSet(type)) {
    return CollectionFieldProcessor(field);
  } else {
    return _isDraftable(type)
        ? DraftableFieldProcessor(field)
        : SimpleFieldProcessor(field);
  }
}

/// Helper to generate a method’s parameter declaration string.
String _generateParameterSignature(List<FormalParameterElement> parameters) {
  final positional = <String>[];
  final named = <String>[];

  for (final p in parameters) {
    final typeStr = p.type.getDisplayString();
    final defaultValue =
        p.defaultValueCode != null ? ' = ${p.defaultValueCode}' : '';
    if (p.isNamed) {
      final prefix = p.isRequiredNamed ? 'required ' : '';
      named.add('$prefix$typeStr ${p.name}$defaultValue');
    } else {
      if (p.isOptionalPositional) {
        positional.add('$typeStr ${p.name}$defaultValue');
      } else {
        positional.add('$typeStr ${p.name}');
      }
    }
  }

  final parts = <String>[];
  if (positional.isNotEmpty) parts.add(positional.join(', '));
  if (named.isNotEmpty) parts.add('{${named.join(', ')}}');

  return parts.join(', ');
}

/// Helper to generate argument list for method calls.
String _generateArgumentList(List<FormalParameterElement> parameters) {
  final positional = <String>[];
  final named = <String>[];

  for (final p in parameters) {
    if (p.isNamed) {
      named.add('${p.name}: ${p.name}');
    } else {
      positional.add(p.name!);
    }
  }

  final parts = <String>[];
  if (positional.isNotEmpty) parts.add(positional.join(', '));
  if (named.isNotEmpty) parts.add(named.join(', '));

  return parts.join(', ');
}

/// Helper to generate constructor parameter signature for draft class based on original constructor.
String _generateDraftConstructorSignature(ConstructorElement? constructor, List<FieldElement> fields) {
  if (constructor == null) {
    // Fallback to named parameters if no constructor found
    final processors = fields.map(_processorFor).toList();
    final params = processors.map((p) => p.generateConstructorParameter()).join(', ');
    return params.isNotEmpty ? '{$params}' : '';
  }

  final positional = <String>[];
  final optionalPositional = <String>[];
  final named = <String>[];

  for (final p in constructor.formalParameters) {
    // Only include parameters that correspond to fields we're processing
    final field = fields.where((f) => f.name == p.name).firstOrNull;
    if (field == null) continue;
    
    final processor = _processorFor(field);
    final paramDecl = processor.generateConstructorParameter();
    
    if (p.isNamed) {
      named.add(paramDecl);
    } else if (p.isOptionalPositional) {
      // For optional positional parameters, extract type and name, add default value
      final match = RegExp(r'required\s+(.+)').firstMatch(paramDecl);
      final typeAndName = match?.group(1) ?? paramDecl;
      final defaultValue = p.defaultValueCode ?? 'null';
      optionalPositional.add('$typeAndName = $defaultValue');
    } else {
      // For required positional parameters, remove 'required' keyword
      final match = RegExp(r'required\s+(.+)').firstMatch(paramDecl);
      if (match != null) {
        positional.add(match.group(1)!);
      } else {
        positional.add(paramDecl);
      }
    }
  }

  final parts = <String>[];
  if (positional.isNotEmpty) parts.add(positional.join(', '));
  if (optionalPositional.isNotEmpty) parts.add('[${optionalPositional.join(', ')}]');
  if (named.isNotEmpty) parts.add('{${named.join(', ')}}');

  return parts.join(', ');
}

/// Helper to generate argument list for save() method based on original constructor.
String _generateSaveArgumentList(ConstructorElement? constructor, List<FieldElement> fields) {
  if (constructor == null) {
    // Fallback to named arguments
    return fields.map((f) => '${f.name}: ${f.name}').join(', ');
  }

  final positional = <String>[];
  final named = <String>[];

  for (final p in constructor.formalParameters) {
    final field = fields.where((f) => f.name == p.name).firstOrNull;
    if (field == null) continue;
    
    if (p.isNamed) {
      named.add('${p.name}: ${field.name}');
    } else {
      positional.add(field.name!);
    }
  }

  final parts = <String>[];
  if (positional.isNotEmpty) parts.add(positional.join(', '));
  if (named.isNotEmpty) parts.add(named.join(', '));

  return parts.join(', ');
}

/// Helper to generate argument list for draft() method based on original constructor.
String _generateDraftArgumentList(ConstructorElement? constructor, List<FieldElement> fields) {
  if (constructor == null) {
    // Fallback to named arguments
    return fields.map((f) => '${f.name}: this.${f.name}').join(', ');
  }

  final positional = <String>[];
  final named = <String>[];

  for (final p in constructor.formalParameters) {
    final field = fields.where((f) => f.name == p.name).firstOrNull;
    if (field == null) continue;
    
    if (p.isNamed) {
      named.add('${p.name}: this.${field.name}');
    } else {
      positional.add('this.${field.name}');
    }
  }

  final parts = <String>[];
  if (positional.isNotEmpty) parts.add(positional.join(', '));
  if (named.isNotEmpty) parts.add(named.join(', '));

  return parts.join(', ');
}

class DraftGenerator extends GeneratorForAnnotation<Draft> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // Process only classes.
    if (element is! ClassElement) return '';

    final classElement = element;
    final className = classElement.name;
    final draftClassName = _draftTypeName(className);

    // Extract generic type parameters.
    final typeParams = classElement.typeParameters;
    final typeParamsDeclaration =
        typeParams.isNotEmpty
            ? '<${typeParams.map((p) => p.displayString()).join(', ')}>'
            : '';
    final typeParamsUsage =
        typeParams.isNotEmpty
            ? '<${typeParams.map((p) => p.name).join(', ')}>'
            : '';

    final constructorName =
        annotation.peek('constructor')?.stringValue; // may be null

    // Build mixin clause.
    String mixinClause = '';
    if (classElement.mixins.isNotEmpty) {
      mixinClause =
          ' with ${classElement.mixins.map((m) => m.getDisplayString()).join(', ')}';
    }

    // Only include actual declared fields (with synthetic getters).
    final fields =
        classElement.fields
            .where((f) => !f.isStatic && f.getter?.isSynthetic == true)
            .toList();
    final processors = fields.map(_processorFor).toList();

    // Field declarations.
    final fieldDeclarations = processors
        .map((p) => p.generateFieldDeclaration())
        .join('\n  ');

    // Getters and setters.
    final getterSetters = processors
        .map((p) => p.generateGetterSetter())
        .join('\n');

    // Find the original constructor to get parameter structure
    final originalConstructor = classElement.constructors
        .where((c) => constructorName == null 
            ? (c.name?.isEmpty ?? true)
            : c.name == constructorName)
        .firstOrNull ?? classElement.unnamedConstructor;

    // Constructor parameters and initializers.
    final constructorParams = _generateDraftConstructorSignature(originalConstructor, fields);
    final initializerList = processors
        .map((p) => p.generateConstructorInitializer())
        .where((init) => init.trim().isNotEmpty)
        .join(',\n    ');

    // Save method arguments based on original constructor.
    final saveArgs = _generateSaveArgumentList(originalConstructor, fields);

    // Determine constructor call for save().
    final constructorCall =
        (constructorName != null && constructorName.isNotEmpty)
            ? '$className.$constructorName'
            : className;

    final buffer = StringBuffer();

    // Begin class declaration with generics and mixins.
    buffer.writeln(
      'class $draftClassName$typeParamsDeclaration $mixinClause implements $className$typeParamsUsage {',
    );
    buffer.writeln('  // Mutable fields');
    buffer.writeln('  $fieldDeclarations\n');
    buffer.writeln('  // Getters and setters for nested draftable fields');
    buffer.writeln(getterSetters);
    buffer.writeln();

    // Generate the constructor WITHOUT generic type parameters in its name.
    if (constructorParams.trim().isNotEmpty) {
      buffer.write('  $draftClassName($constructorParams)');
    } else {
      buffer.write('  $draftClassName()');
    }
    if (initializerList.trim().isNotEmpty) {
      buffer.writeln(' :\n    $initializerList;');
    } else {
      buffer.writeln(';');
    }
    buffer.writeln();

    // Generate the save() method.
    if (saveArgs.trim().isNotEmpty) {
      buffer.writeln(
        '  $className$typeParamsUsage save() => $constructorCall($saveArgs);',
      );
    } else {
      buffer.writeln(
        '  $className$typeParamsUsage save() => $constructorCall();',
      );
    }
    buffer.writeln();

    // Forward computed getters.
    final handledNames = fields.map((f) => f.name).toSet();
    for (final accessor in classElement.getters.where(
      (a) => !a.isSynthetic && !handledNames.contains(a.name),
    )) {
      final returnType = accessor.returnType.getDisplayString();
      buffer.writeln('  @override');
      buffer.writeln(
        '  $returnType get ${accessor.displayName} => save().${accessor.displayName};',
      );
    }
    buffer.writeln();

    // Forward non-static, public instance methods.
    for (final method in classElement.methods.where(
      (m) => !m.isStatic && m.isPublic && !m.isOperator && m.name != 'save',
    )) {
      final returnType = method.returnType.getDisplayString();
      final paramsSignature = _generateParameterSignature(
        method.formalParameters,
      );
      final argsList = _generateArgumentList(method.formalParameters);
      final typeParamsForMethod =
          method.typeParameters.isNotEmpty
              ? '<${method.typeParameters.map((tp) => tp.name).join(', ')}>'
              : '';
      buffer.writeln('  @override');
      if (method.returnType is VoidType) {
        buffer.writeln(
          '  void ${method.name}$typeParamsForMethod($paramsSignature) => save().${method.name}($argsList);',
        );
      } else {
        buffer.writeln(
          '  $returnType ${method.name}$typeParamsForMethod($paramsSignature) => save().${method.name}($argsList);',
        );
      }
    }

    buffer.writeln('}');
    buffer.writeln();

    // Generate extension for draft() and produce() helpers.
    buffer.writeln(
      'extension ${className}DraftExtension$typeParamsDeclaration on $className$typeParamsUsage {',
    );
    final draftArgs = _generateDraftArgumentList(originalConstructor, fields);
    if (draftArgs.trim().isNotEmpty) {
      buffer.writeln(
        '  $draftClassName$typeParamsUsage draft() => $draftClassName($draftArgs);',
      );
    } else {
      buffer.writeln(
        '  $draftClassName$typeParamsUsage draft() => $draftClassName();',
      );
    }
    buffer.writeln(
      '  $className$typeParamsUsage produce(void Function($draftClassName$typeParamsUsage draft) producer) {',
    );
    buffer.writeln('    final draft = this.draft();');
    buffer.writeln('    producer(draft);');
    buffer.writeln('    return draft.save();');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }
}
