import 'package:test/test.dart';

import 'common.dart';

void main() {
  test('compiles', () async {
    await expectLater(
      compile(r'''
import 'empty.dart';

void main() {
  Empty();
  Empty().draft().save();
  Empty().produce((draft) {});
}
'''),
      completes,
    );
  });
}
