import 'package:analyzer/dart/element/type.dart';

extension DartTypeX on DartType {
  String getCodeName([String suffix = '']) => '${getDisplayString()}$suffix';
}
