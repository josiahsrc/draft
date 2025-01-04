import 'package:draft/draft.dart';

void main() {
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');
}

@Hello()
class Something {}
