import 'package:draft/draft.dart';

part 'mixed_params.draft.dart';

@draft
class InnerParams {
  final int value1;
  final int value2;

  InnerParams(this.value1, {required this.value2});
}

@draft
class MixedParams {
  final int value1;
  final int value2;
  final InnerParams innerA;
  final InnerParams innerB;

  MixedParams(
    this.value1,
    this.innerA, {
    required this.value2,
    required this.innerB,
  });
}
