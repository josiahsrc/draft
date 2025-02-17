import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:draft/src/utility.dart';
import 'package:source_gen/source_gen.dart';

// ignore: implementation_imports
import 'package:draft_annotation/src/draft.dart';

class DraftGenerator extends GeneratorForAnnotation<Draft> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) return '';
    final classElement = element;
    final className = classElement.name;
    final draftClassName = '${className}Draft';

    // Collect instance fields (typically final) to replicate in the draft.
    final fields = classElement.fields
        .where((field) => !field.isStatic && field.isFinal)
        .toList();

    // Build lists for different code sections.
    final List<String> normalFieldDeclarations = [];
    final List<String> nestedFieldDeclarations = [];
    final List<String> constructorParams = [];
    final List<String> saveArgumentsList = [];
    final List<String> extensionFieldInitializers = [];

    for (final field in fields) {
      final isNullable =
          field.type.nullabilitySuffix == NullabilitySuffix.question;

      // Branch: if field type itself is annotated with @Draft.
      bool isDirectDraftable = false;
      if (field.type.element is ClassElement) {
        final fieldClass = field.type.element as ClassElement;
        isDirectDraftable = fieldClass.metadata.any((m) =>
            m.element?.enclosingElement3?.name == 'Draft' ||
            m.element?.name == 'draft');
      }
      if (isDirectDraftable) {
        final nestedType = field.type.getCodeName('Draft');
        // Declare backing field, getter and setter.
        nestedFieldDeclarations.add('  $nestedType ${field.name};');
        // Constructor gets the nested draft.
        constructorParams.add('required this.${field.name}');
        // In save, call the nested draft's save.
        saveArgumentsList.add('${field.name}: ${field.name}.save()');
        // In extension, initialize by drafting the nested object.
        extensionFieldInitializers
            .add('${field.name}: this.${field.name}.draft()');
      } else if (field.type.isDartCoreList ||
          field.type.isDartCoreSet ||
          field.type.isDartCoreMap) {
        // Handle collection types.
        final type = field.type.getCodeName();
        normalFieldDeclarations.add('  $type ${field.name};');
        constructorParams.add('required this.${field.name}');
        // Determine generic draftability.
        bool isGenericDraftable = false;
        if (field.type is ParameterizedType) {
          final typeArgs = (field.type as ParameterizedType).typeArguments;
          if (field.type.isDartCoreMap && typeArgs.length == 2) {
            final valueType = typeArgs[1];
            if (valueType.element is ClassElement) {
              final valueClass = valueType.element as ClassElement;
              isGenericDraftable = valueClass.metadata.any((m) =>
                  m.element?.enclosingElement3?.name == 'Draft' ||
                  m.element?.name == 'draft');
            }
          } else if (typeArgs.isNotEmpty) {
            final itemType = typeArgs.first;
            if (itemType.element is ClassElement) {
              final itemClass = itemType.element as ClassElement;
              isGenericDraftable = itemClass.metadata.any((m) =>
                  m.element?.enclosingElement3?.name == 'Draft' ||
                  m.element?.name == 'draft');
            }
          }
        }
        // Extension initializer conversion (object -> draft)
        if (field.type.isDartCoreList) {
          if (isGenericDraftable) {
            extensionFieldInitializers.add(
                "${field.name}: this.${field.name}.map((e) => e.draft()).toList()");
            saveArgumentsList.add(
                "${field.name}: ${field.name}.map((e) => e.save()).toList()");
          } else if (!isNullable) {
            extensionFieldInitializers
                .add("${field.name}: List.from(this.${field.name})");
            saveArgumentsList.add("${field.name}: List.from(${field.name})");
          } else {
            extensionFieldInitializers.add(
                "${field.name}: ${field.name} == null ? null : List.from(this.${field.name}!)");
            saveArgumentsList.add(
                "${field.name}: ${field.name} == null ? null : List.from(${field.name}!)");
          }
        } else if (field.type.isDartCoreSet) {
          if (isGenericDraftable) {
            extensionFieldInitializers.add(
                "${field.name}: this.${field.name}.map((e) => e.draft()).toSet()");
            saveArgumentsList.add(
                "${field.name}: ${field.name}.map((e) => e.save()).toSet()");
          } else if (!isNullable) {
            extensionFieldInitializers
                .add("${field.name}: Set.from(this.${field.name})");
            saveArgumentsList.add("${field.name}: Set.from(${field.name})");
          } else {
            extensionFieldInitializers.add(
                "${field.name}: ${field.name} == null ? null : Set.from(this.${field.name}!)");
            saveArgumentsList.add(
                "${field.name}: ${field.name} == null ? null : Set.from(${field.name}!)");
          }
        } else if (field.type.isDartCoreMap) {
          // For Map, assume key remains unchanged.
          if (isGenericDraftable) {
            extensionFieldInitializers.add(
                "${field.name}: this.${field.name}.map((k, v) => MapEntry(k, v.draft()))");
            saveArgumentsList.add(
                "${field.name}: ${field.name}.map((k, v) => MapEntry(k, v.save()))");
          } else if (!isNullable) {
            extensionFieldInitializers
                .add("${field.name}: Map.from(this.${field.name})");
            saveArgumentsList.add("${field.name}: Map.from(${field.name})");
          } else {
            extensionFieldInitializers.add(
                "${field.name}: ${field.name} == null ? null : Map.from(this.${field.name}!)");
            saveArgumentsList.add(
                "${field.name}: ${field.name} == null ? null : Map.from(${field.name}!)");
          }
        }
      } else {
        // Plain field.
        final type = field.type.getCodeName();
        normalFieldDeclarations.add('  $type ${field.name};');
        constructorParams.add('required this.${field.name}');
        saveArgumentsList.add('${field.name}: ${field.name}');
        extensionFieldInitializers.add('${field.name}: this.${field.name}');
      }
    }

    final fieldDeclarations = [
      ...normalFieldDeclarations,
      ...nestedFieldDeclarations,
    ].join('\n');

    final draftClass = '''
class $draftClassName {
$fieldDeclarations

  $draftClassName({${constructorParams.join(', ')}});

  $className save() => $className(${saveArgumentsList.join(', ')});
}
''';

    final draftExtension = '''
extension ${className}DraftExtension on $className {
  $draftClassName draft() => $draftClassName(
      ${extensionFieldInitializers.join(',\n      ')});

  $className produce(void Function($draftClassName draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}
''';

    return '''
$draftClass

$draftExtension
''';
  }
}
