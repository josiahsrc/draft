import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:draft_annotation/draft_annotation.dart';

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
    final List<String> constructorInitializers = [];
    final List<String> saveArgumentsList = [];
    final List<String> extensionFieldInitializers = [];

    for (final field in fields) {
      bool isDraftable = false;
      if (field.type.element is ClassElement) {
        final fieldClass = field.type.element as ClassElement;
        isDraftable = fieldClass.metadata.any((m) =>
            m.element?.enclosingElement3?.name == 'Draft' ||
            m.element?.name == 'draft');
      }
      if (isDraftable) {
        final originalType = field.type.getDisplayString();
        final nestedType = '${originalType}Draft';
        // Declare backing field, getter and setter.
        nestedFieldDeclarations.add('  $nestedType _${field.name};');
        nestedFieldDeclarations.add('  $nestedType get ${field.name} => _${field.name};');
        nestedFieldDeclarations.add('  set ${field.name}($originalType value) => _${field.name} = value.draft();');
        // Constructor gets the nested draft.
        constructorParams.add('required $nestedType ${field.name}');
        constructorInitializers.add('_${field.name} = ${field.name}');
        // In save, call the nested draft's save.
        saveArgumentsList.add('${field.name}: ${field.name}.save()');
        // In extension, initialize by drafting the nested object.
        extensionFieldInitializers.add('${field.name}: this.${field.name}.draft()');
      } else {
        final type = field.type.getDisplayString();
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
class $draftClassName implements $className {
$fieldDeclarations

  $draftClassName({${constructorParams.join(', ')}})
      ${constructorInitializers.isNotEmpty ? ': ' : ''}${constructorInitializers.join(', ')};

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
