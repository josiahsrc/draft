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

    // Generate mutable field declarations for the draft class.
    final fieldDeclarations = fields.map((field) {
      final type = field.type.getDisplayString();
      return '  $type ${field.name};';
    }).join('\n');

    // Create constructor parameter list with required keyword.
    final constructorParams =
        fields.map((field) => 'required this.${field.name}').join(', ');

    // Map draft fields back to the original class’s constructor arguments.
    final saveArguments =
        fields.map((field) => '${field.name}: ${field.name}').join(', ');

    final draftClass = '''
class $draftClassName {
$fieldDeclarations

  $draftClassName({$constructorParams});

  $className save() => $className($saveArguments);
}
''';

    // Create extension methods for functional (produce) and builder (draft) styles.
    final draftExtension = '''
extension ${className}DraftExtension on $className {
  $draftClassName draft() => $draftClassName(${fields.map((f) => '${f.name}: this.${f.name}').join(', ')});

  $className produce(void Function($draftClassName draft) update) {
    final draft = this.draft();
    update(draft);
    return draft.save();
  }
}
''';

    // Use the input file’s name for the part directive.
    return '''
$draftClass

$draftExtension
''';
  }
}
