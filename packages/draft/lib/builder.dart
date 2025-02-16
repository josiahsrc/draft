import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/draft_generator.dart';

Builder draftBuilder(BuilderOptions options) =>
    SharedPartBuilder([DraftGenerator()], 'draft');
