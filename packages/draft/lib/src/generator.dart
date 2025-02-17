import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:draft_annotation/draft_annotation.dart';
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

/// Returns the draft type name for a given type.
/// For example, if the original is `Inner` then the draft type is `InnerDraft`.
String _draftTypeName(String originalName) => '${originalName}Draft';

/// Recursively converts a DartType into the drafted type name.
/// For collections it recurses into type arguments.
String _toDraftedTypeName(DartType type) {
  if (_isPrimitive(type)) {
    return type.getDisplayString(withNullability: false);
  } else if (_isList(type)) {
    final listArg = (type as ParameterizedType).typeArguments.first;
    return 'List<${_toDraftedTypeName(listArg)}>';
  } else if (_isMap(type)) {
    final paramType = type as ParameterizedType;
    final keyType =
        paramType.typeArguments[0].getDisplayString(withNullability: false);
    final valueType = paramType.typeArguments[1];
    return 'Map<$keyType, ${_toDraftedTypeName(valueType)}>';
  } else {
    // For non-primitive, non-collection types, assume they are draftable.
    return _draftTypeName(type.getDisplayString(withNullability: false));
  }
}

/// Given a DartType, produce an expression that converts a value into its draft.
/// For primitives, returns the value as is; for draftable objects, calls `.draft()`;
/// for collections, it recursively maps the conversion.
String _toDraftExpression(String expr, DartType type) {
  if (_isPrimitive(type)) {
    return expr;
  } else if (_isList(type)) {
    final listArg = (type as ParameterizedType).typeArguments.first;
    return '$expr.map((e) => ${_toDraftExpression("e", listArg)}).toList()';
  } else if (_isMap(type)) {
    final paramType = type as ParameterizedType;
    final valueType = paramType.typeArguments[1];
    return '$expr.map((k, v) => MapEntry(k, ${_toDraftExpression("v", valueType)}))';
  } else {
    // Assume non-primitive and non-collection types are draftable.
    return '$expr.draft()';
  }
}

/// Given a DartType produce an expression that “saves” a draft field back to its original.
/// For primitives, returns as is; for draftable objects, calls `.save()`; for collections,
/// it recursively maps the conversion.
String _toSaveExpression(String expr, DartType type) {
  if (_isPrimitive(type)) {
    return expr;
  } else if (_isList(type)) {
    final listArg = (type as ParameterizedType).typeArguments.first;
    return '$expr.map((e) => ${_toSaveExpression("e", listArg)}).toList()';
  } else if (_isMap(type)) {
    final paramType = type as ParameterizedType;
    final valueType = paramType.typeArguments[1];
    return '$expr.map((k, v) => MapEntry(k, ${_toSaveExpression("v", valueType)}))';
  } else {
    return '$expr.save()';
  }
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
  PrimitiveFieldProcessor(FieldElement field) : super(field);

  @override
  String generateFieldDeclaration() {
    return '${field.type.getDisplayString(withNullability: true)} ${field.name};';
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

/// Processor for fields that are nested draftable objects.
class DraftableFieldProcessor extends FieldProcessor {
  DraftableFieldProcessor(FieldElement field) : super(field);

  String get privateName => '_${field.name}';
  String get originalType =>
      field.type.getDisplayString(withNullability: false);
  String get draftType => _draftTypeName(originalType);

  @override
  String generateFieldDeclaration() {
    // Store the draft version in a private field.
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
    // The constructor accepts the original type.
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

/// Processor for collection fields (List or Map) where inner types may be draftable.
class CollectionFieldProcessor extends FieldProcessor {
  CollectionFieldProcessor(FieldElement field) : super(field);

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
    final originalType = field.type.getDisplayString(withNullability: true);
    return '''
  ${_draftedCollectionType()} get ${field.name} => $privateName;
  set ${field.name}($originalType value) => $privateName = ${_toDraftExpression("value", field.type)};
''';
  }

  @override
  String generateConstructorParameter() {
    return 'required ${field.type.getDisplayString(withNullability: true)} ${field.name}';
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
  } else if (_isList(type) || _isMap(type)) {
    return CollectionFieldProcessor(field);
  } else {
    return DraftableFieldProcessor(field);
  }
}

/// Helper to generate a method’s parameter declaration string.
String _generateParameterSignature(List<ParameterElement> parameters) {
  final positional = <String>[];
  final named = <String>[];

  for (final p in parameters) {
    final typeStr = p.type.getDisplayString(withNullability: true);
    final defaultValue =
        p.defaultValueCode != null ? ' = ${p.defaultValueCode}' : '';
    if (p.isNamed) {
      final prefix = p.isRequiredNamed ? 'required ' : '';
      named.add('$prefix$typeStr ${p.name}$defaultValue');
    } else {
      if (p.isOptionalPositional) {
        positional.add('$typeStr ${p.name}$defaultValue');
      } else {
        positional.add('required $typeStr ${p.name}');
      }
    }
  }

  final parts = <String>[];
  if (positional.isNotEmpty) parts.add(positional.join(', '));
  if (named.isNotEmpty) parts.add('{${named.join(', ')}}');

  return parts.join(', ');
}

/// Helper to generate an argument list for forwarding a method call.
String _generateArgumentList(List<ParameterElement> parameters) {
  final positional = <String>[];
  final named = <String>[];

  for (final p in parameters) {
    if (p.isNamed) {
      named.add('${p.name}: ${p.name}');
    } else {
      positional.add(p.name);
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

    final classElement = element as ClassElement;
    final className = classElement.name;
    final draftClassName = _draftTypeName(className);
    final constructorName =
        annotation.peek('constructor')?.stringValue; // may be null

    // Only include actual declared fields (with synthetic getters).
    final fields = classElement.fields
        .where((f) => !f.isStatic && f.getter?.isSynthetic == true)
        .toList();

    final processors = fields.map(_processorFor).toList();

    // Field declarations.
    final fieldDeclarations =
        processors.map((p) => p.generateFieldDeclaration()).join('\n  ');

    // Getters and setters.
    final getterSetters =
        processors.map((p) => p.generateGetterSetter()).join('\n');

    // Constructor parameters and initializers.
    final constructorParams =
        processors.map((p) => p.generateConstructorParameter()).join(', ');
    final initializerList = processors
        .map((p) => p.generateConstructorInitializer())
        .where((init) => init.trim().isNotEmpty)
        .join(',\n    ');

    // Save method assignments.
    final saveAssignments =
        processors.map((p) => p.generateSaveAssignment()).join(',\n      ');

    // Determine constructor call for save().
    final constructorCall =
        (constructorName != null && constructorName.isNotEmpty)
            ? '$className.$constructorName'
            : className;

    final buffer = StringBuffer();

    // Begin class declaration.
    buffer.writeln('class $draftClassName implements $className {');
    buffer.writeln('  // Mutable fields');
    buffer.writeln('  $fieldDeclarations\n');
    buffer.writeln('  // Getters and setters for nested draftable fields');
    buffer.writeln(getterSetters);
    buffer.writeln();

    // Generate the constructor.
    buffer.write('  $draftClassName({$constructorParams})');
    if (initializerList.trim().isNotEmpty) {
      buffer.writeln(' :\n    $initializerList;');
    } else {
      buffer.writeln(';');
    }
    buffer.writeln();

    // Generate the save() method.
    buffer.writeln('  @override');
    buffer.writeln('  $className save() => $constructorCall(');
    buffer.writeln('      $saveAssignments');
    buffer.writeln('  );');
    buffer.writeln();

    // Forward computed getters (if any) that are not already handled by fields.
    final handledNames = fields.map((f) => f.name).toSet();
    for (final accessor in classElement.accessors.where((a) =>
        a.isGetter && !a.isSynthetic && !handledNames.contains(a.name))) {
      final returnType =
          accessor.returnType.getDisplayString(withNullability: true);
      buffer.writeln('  @override');
      buffer.writeln(
          '  $returnType get ${accessor.displayName} => save().${accessor.displayName};');
    }
    buffer.writeln();

    // Forward all non-static, public instance methods (except the save() method).
    for (final method in classElement.methods.where((m) =>
        !m.isStatic && m.isPublic && !m.isOperator && m.name != 'save')) {
      final returnType =
          method.returnType.getDisplayString(withNullability: true);
      final paramsSignature = _generateParameterSignature(method.parameters);
      final argsList = _generateArgumentList(method.parameters);
      final typeParams = method.typeParameters.isNotEmpty
          ? '<${method.typeParameters.map((tp) => tp.name).join(', ')}>'
          : '';
      buffer.writeln('  @override');
      if (method.returnType.isVoid) {
        buffer.writeln(
            '  void ${method.name}$typeParams($paramsSignature) => save().${method.name}($argsList);');
      } else {
        buffer.writeln(
            '  $returnType ${method.name}$typeParams($paramsSignature) => save().${method.name}($argsList);');
      }
    }

    buffer.writeln('}');
    buffer.writeln();

    // Generate an extension for the .draft() helper and now the produce() helper.
    buffer.writeln('extension ${className}DraftExtension on $className {');
    buffer.writeln(
        '  $draftClassName draft() => $draftClassName(${fields.map((f) => '${f.name}: this.${f.name}').join(', ')});');
    buffer.writeln(
        '  $className produce(void Function($draftClassName draft) producer) {');
    buffer.writeln('    final draft = this.draft();');
    buffer.writeln('    producer(draft);');
    buffer.writeln('    return draft.save();');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }
}
